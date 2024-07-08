use std::process::Command;

fn main() {
    Command::new("bun")
        .current_dir("src_fe")
        .arg("run")
        .arg("build")
        .output()
        .expect("Failed to execute frontend build");
}
