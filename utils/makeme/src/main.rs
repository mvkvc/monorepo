use std::env::current_dir;

use clap::Parser;
use glob::glob;
use relative_path::RelativePath;
use serde::{Serialize, Deserialize};
use serde_yml;

const LEVELS: u8 = 2;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    #[arg(short, long, default_value = "./README.md")]
    output: String,

    #[arg(short, long, default_value = "")]
    root: String
}

#[derive(Serialize, Deserialize, PartialEq, Debug)]
struct User {
    name: String,
    description: String,
    #[serde(default)]
    is_active: bool,
}

fn main() {
    let args = Args::parse();

    let root = RelativePath::new(&args.root);
    let current_dir = current_dir().expect("Failed to get current directory");
    let root_full = root.to_path(current_dir);

    let mut glob_pattern = String::from(root_full.to_str().unwrap());

    for _ in 0..LEVELS {
        glob_pattern.push_str("/*");
    }

    glob_pattern.push_str("/README.md");

    match glob(&glob_pattern) {
        Ok(paths) => {
            for entry in paths {
                match entry {
                    Ok(path) => println!("Found: {:?}", path.display()),
                    Err(e) => println!("Error reading glob entry: {:?}", e),
                }
            }
        }
        Err(e) => println!("Error with glob pattern: {:?}", e),
    }
}

// Tesed example from serde_yml
// use serde::{Serialize, Deserialize};
// use serde_yml;

// #[derive(Serialize, Deserialize, PartialEq, Debug)]
// struct User {
//     name: String,
//     age: Option<u32>,
//     #[serde(default)]
//     is_active: bool,
// }

// fn main() -> Result<(), serde_yml::Error> {
//     let user = User {
//         name: "John".to_string(),
//         age: None,
//         is_active: true,
//     };

//     // Serialize to YAML
//     // let yaml = serde_yml::to_string(&user)?;
//     let yaml = "name: John\nage: null\nis_active: true";
//     println!("Serialized YAML:\n{}", yaml);

//     // Deserialize from YAML
//     let deserialized_user: User = serde_yml::from_str(&yaml)?;
//     assert_eq!(user, deserialized_user);

//     Ok(())
// }
