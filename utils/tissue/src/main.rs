#[macro_use]
extern crate rocket;
extern crate dirs;

use std::borrow::Cow;
use std::ffi::OsStr;

use rocket::http::ContentType;
use rocket::response::content::RawHtml;
use rust_embed::Embed;
use std::path::PathBuf;
use webbrowser;

#[derive(Embed)]
#[folder = "./dist"]
struct Asset;

#[get("/")]
async fn index() -> Option<RawHtml<Cow<'static, [u8]>>> {
    let asset = Asset::get("index.html")?;
    Some(RawHtml(asset.data))
}

#[get("/<file..>")]
async fn dist(file: PathBuf) -> Option<(ContentType, Cow<'static, [u8]>)> {
    let filename = file.display().to_string();
    let asset = Asset::get(&filename)?;
    let content_type = file
        .extension()
        .and_then(OsStr::to_str)
        .and_then(ContentType::from_extension)
        .unwrap_or(ContentType::Bytes);

    Some((content_type, asset.data))
}

#[launch]
fn rocket() -> _ {
    let address = "0.0.0.0";
    let port = 8888;

    let figment = rocket::Config::figment()
        .merge(("address", address))
        .merge(("port", port));

    let server = rocket::custom(figment).mount(
        "/",
        routes![
            index, dist
        ],
    );
    let url = format!("http://{}:{}", address, port);
    webbrowser::open(&url).unwrap();

    server
}
