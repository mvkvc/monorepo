#[macro_use]
extern crate rocket;
extern crate dirs;

use std::borrow::Cow;
use std::ffi::OsStr;
// use std::fs;

use rocket::http::ContentType;
use rocket::response::content::RawHtml;
// use rocket_db_pools::sqlx::Row;
// use rocket_db_pools::{sqlx, Connection, Database};
use rust_embed::Embed;
use std::path::PathBuf;
use webbrowser;

// #[derive(Database)]
// #[database("sqlite_logs")]
// struct Logs(sqlx::SqlitePool);

#[derive(Embed)]
#[folder = "./dist"]
struct Asset;

// #[get("/logs/<id>")]
// async fn logs(mut db: Connection<Logs>, id: i64) -> Option<Log> {
//     sqlx::query("SELECT content FROM logs WHERE id = ?")
//         .bind(id)
//         .fetch_one(&mut **db)
//         .await
//         .and_then(|r| Ok(Log(r.try_get(0)?)))
//         .ok()
// }

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
    // let path_config_app = "tissue";
    // let path_db = "tissue.db";

    // let path_config = dirs::config_dir().expect("Failed to determine config directory");
    // let app_dir = path_config.join(path_config_app);
    // if !app_dir.exists() {
    //     fs::create_dir_all(&app_dir)?;
    // }
    // let db_path = app_dir.join("tissue.db");

    let figment = rocket::Config::figment()
        .merge(("address", address))
        .merge(("port", port));
    // .merge(("databases.sqlite_logs.url", db_path));

    let server = rocket::custom(figment).mount(
        "/",
        routes![
            index, dist,
            // logs
        ],
    );
    // .attach(Logs::init());

    let url = format!("http://{}:{}", address, port);
    webbrowser::open(&url).unwrap();

    server
}
