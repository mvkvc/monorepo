#[macro_use]
extern crate rocket;

use relative_path::RelativePath;
use rocket::fs::NamedFile;
use std::env::current_dir;
use std::path::PathBuf;
use webbrowser;

const BUNDLE_PATH: &str = "./dist";

fn get_bundle_path(relative_path: Option<&str>) -> PathBuf {
    let path_relative = RelativePath::new(BUNDLE_PATH);
    let path_bundle = match relative_path {
        Some(path) => path_relative.join(path),
        None => path_relative.into(),
    };
    let path_current = current_dir().expect("Failed to get current directory");
    path_bundle.to_path(path_current)
}

#[get("/")]
async fn root() -> Option<NamedFile> {
    let path = get_bundle_path(Some("index.html"));
    NamedFile::open(path).await.ok()
}

#[get("/<file..>")]
async fn files(file: PathBuf) -> Option<NamedFile> {
    let path = get_bundle_path(None).join(file);
    NamedFile::open(path).await.ok()
}

#[launch]
fn rocket() -> _ {
    let address = "0.0.0.0";
    let port = 8888;

    let figment = rocket::Config::figment()
        .merge(("address", address))
        .merge(("port", port));

    let server = rocket::custom(figment).mount("/", routes![root, files]);

    let url = format!("http://{}:{}", address, port);
    webbrowser::open(&url).unwrap();

    server
}
