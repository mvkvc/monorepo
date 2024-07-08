use clap::Parser;
use glob::glob;
use relative_path::RelativePath;
use std::env::current_dir;

const LEVELS: u8 = 2;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    #[arg(short, long, default_value = "./README.md")]
    output: String,

    #[arg(short, long, default_value = "")]
    root: String
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
