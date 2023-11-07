use axum::{extract::Path, response::Json, routing::get, Router};
use http::{Method, StatusCode};
use serde_json::{json, Value};
use solana_client::rpc_client::RpcClient;
use solana_sdk::pubkey::Pubkey;
use std::env;
use std::str::FromStr;
use std::sync::Arc;
use tokio;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};

fn round_to(n: f64, precision: u32) -> f64 {
    let prec = 10.0_f64.powi(precision as i32);
    (n * prec).round() / prec
}

async fn fetch_query(address: String, client: Arc<RpcClient>) -> Result<(f64, bool), ()> {
    let pubkey = Pubkey::from_str(&address).map_err(|_| ())?;
    let account_info = client.get_account(&pubkey).map_err(|_| ())?;
    let balance = round_to(account_info.lamports as f64 / 1_000_000_000_f64, 6);
    let executable = account_info.executable;
    Ok((balance, executable))
}

async fn query(
    Path(address): Path<String>,
    client: Arc<RpcClient>,
) -> Result<Json<Value>, (StatusCode, String)> {
    if !Pubkey::from_str(&address).is_ok() {
        return Err((StatusCode::BAD_REQUEST, "Invalid public key".to_string()));
    }

    match fetch_query(address, client).await {
        Ok((balance, executable)) => {
            let response = json!({
                "balance": balance,
                "is_executable": executable,
            });
            Ok(Json(response))
        }
        Err(_) => Err((
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to fetch query".to_string(),
        )),
    }
}

#[tokio::main]
async fn main() {
    let api_key = match env::var("RPC_API_KEY") {
        Ok(key) => key,
        Err(_) => {
            eprintln!("RPC_API_KEY environment variable not set");
            return;
        }
    };
    let rpc_url = format!("https://mainnet.helius-rpc.com/?api-key={}", api_key);
    let client = RpcClient::new(&rpc_url);
    let shared_client = Arc::new(client);

    let app = Router::new()
        .route("/", get(|| async { "I'm alive!" }))
        .route(
            "/query/:address",
            get(move |address: Path<String>| async move {
                let client_clone = shared_client.clone();
                query(address, client_clone).await
            }),
        )
        .layer(
            ServiceBuilder::new().layer(
                CorsLayer::new()
                    .allow_methods([Method::GET])
                    .allow_origin(Any),
            ),
        );

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
