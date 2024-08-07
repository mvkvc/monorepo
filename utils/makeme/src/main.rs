use std::env::current_dir;
use std::fs;

use clap::Parser;
use glob::glob;
use regex::Regex;
use relative_path::RelativePath;
use serde::{Deserialize, Serialize};
use serde_yml;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    #[arg(short, long, default_value = "../../README.md")]
    target: String,

    #[arg(short, long, default_value = "../..")]
    root: String,

    #[arg(short, long, default_value = "2")]
    levels: u8,

    #[arg(short, long, default_value = "")]
    exclude: String,

    #[arg(short, long)]
    dry_run: bool,
}

#[derive(Serialize, Deserialize, PartialEq, Debug)]
struct ProjectFrontmatter {
    name: String,
    desc: String,
    tech: Option<String>,
    link: Option<String>,
    #[serde(default = "default_show")]
    show: bool,
}

#[derive(Serialize, Deserialize, PartialEq, Debug)]
struct Project {
    name: String,
    path: String,
    desc: String,
    tech: Option<String>,
    link: Option<String>,
}

fn default_show() -> bool {
    true
}

fn frontmatter_to_project(frontmatter: ProjectFrontmatter, path: &str) -> Project {
    Project {
        name: frontmatter.name,
        path: path.to_string(),
        desc: frontmatter.desc,
        tech: frontmatter.tech,
        link: frontmatter.link,
    }
}

fn extract_frontmatter(content: &str) -> Option<String> {
    let re = Regex::new(r"(?s)^---\s*\n(.*?)\n---\s*\n").unwrap();

    re.captures(content).map(|cap| cap[1].trim().to_string())
}

fn extract_frontmatter_struct(path: &str) -> Option<ProjectFrontmatter> {
    let content = fs::read_to_string(path).ok()?;
    let frontmatter = extract_frontmatter(&content)?;
    let project_frontmatter: ProjectFrontmatter = serde_yml::from_str(&frontmatter).ok()?;

    if project_frontmatter.show {
        Some(project_frontmatter)
    } else {
        None
    }
}

fn template_project(project: Project) -> String {
    let mut result = String::new();
    result.push_str(&format!(
        "- [{}]({})\n    - {}",
        project.name, project.path, project.desc
    ));

    if project.tech.is_some() || project.link.is_some() {
        if let Some(tech) = &project.tech {
            result.push_str(&format!("\n    - *Tech: {}*", tech));
        }

        if let Some(link) = &project.link {
            result.push_str(&format!("\n    - *Link: {}*", link));
        }
    }

    result
}

fn main() {
    let args = Args::parse();

    println!("Running MAKEME with: {:?}", args);

    let root = RelativePath::new(&args.root);
    let current_dir = current_dir().expect("Failed to get current directory");
    let root_full = root.to_path(&current_dir);
    let mut glob_pattern = String::from(root_full.to_str().unwrap());

    for _ in 0..args.levels {
        glob_pattern.push_str("/*");
    }

    glob_pattern.push_str("/README.md");

    let exclude: Vec<&str> = if args.exclude.is_empty() {
        Vec::new()
    } else {
        args.exclude.split(',').collect()
    };

    let mut projects = Vec::new();

    match glob(&glob_pattern) {
        Ok(paths) => {
            for entry in paths {
                match entry {
                    Ok(path) => {
                        let path_str = path.to_string_lossy();
                        if !exclude.iter().any(|&x| path_str.contains(x)) {
                            let canonical_path = fs::canonicalize(&path).unwrap();
                            if let Some(project_frontmatter) =
                                extract_frontmatter_struct(canonical_path.to_str().unwrap())
                            {
                                let relative_path = path.strip_prefix(&root_full).unwrap();
                                let relative_path_str =
                                    format!("./{}", relative_path.to_str().unwrap())
                                        .replace("\\", "/");
                                let project =
                                    frontmatter_to_project(project_frontmatter, &relative_path_str);
                                projects.push(project);
                            }
                        }
                    }
                    Err(e) => println!("Error reading glob entry: {:?}", e),
                }
            }
        }
        Err(e) => println!("Error with glob pattern: {:?}", e),
    }

    if projects.is_empty() {
        println!("No projects found. No changes will be made to the target file.");
        return;
    }

    projects.sort_by(|a, b| a.name.cmp(&b.name));
    let output_projects = projects
        .into_iter()
        .map(template_project)
        .collect::<Vec<String>>()
        .join("\n");
    let output = format!(
        "<!-- THIS SECTION IS AUTOGENERATED -->\n{}",
        output_projects
    );

    let marker_start = "<!-- MAKEME START -->\n";
    let marker_end = "\n<!-- MAKEME END -->";
    let target_path = RelativePath::new(&args.target).to_path(&current_dir);
    let content = fs::read_to_string(&target_path).unwrap();

    if let (Some(start), Some(end)) = (content.find(marker_start), content.find(marker_end)) {
        let before = &content[..start + marker_start.len()];
        let after = &content[end..];
        let new_content = before.to_string() + &output + after;

        if args.dry_run {
            println!("{}", output);
        } else {
            fs::write(&target_path, new_content).unwrap();
        };
    } else {
        println!("Could not find both start and end markers in the target file.");
    };
}
