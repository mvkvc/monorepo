// #[rustler::nif]
// fn add(a: i64, b: i64) -> i64 {
//     a + b
// }

use pyth_sdk_solana::load_price_feed_from_account;
use solana_client::rpc_client::RpcClient;
use solana_program::pubkey::Pubkey;
use std::str::FromStr;
use std::time::{
    SystemTime,
    UNIX_EPOCH,
};
// use std::{
//     thread,
//     time,
// };

#[rustler::nif]
fn query(url: &str, key: &str, max_delay: u64) -> i64 {
    let client = RpcClient::new(url.to_string());
    let price_key = Pubkey::from_str(key).unwrap();

    let mut price_account = client.get_account(&price_key).unwrap();
    let price_feed =
        load_price_feed_from_account(&price_key, &mut price_account).unwrap();

    let current_time = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_secs() as i64;


    let maybe_price = price_feed.get_price_no_older_than(current_time, max_delay);
    match maybe_price {
        Some(p) => {
            println!("price ........... {} x 10^{}", p.price, p.expo);
            println!("conf ............ {} x 10^{}", p.conf, p.expo);
            p.price
        }
        None => {
            println!("price ........... unavailable");
            println!("conf ............ unavailable");
            -1
        }
    }

    // let maybe_ema_price = price_feed.get_ema_price_no_older_than(current_time, 60);
    // match maybe_ema_price {
    //     Some(ema_price) => {
    //         println!(
    //             "ema_price ....... {} x 10^{}",
    //             ema_price.price, ema_price.expo
    //         );
    //         println!(
    //             "ema_conf ........ {} x 10^{}",
    //             ema_price.conf, ema_price.expo
    //         );
    //     }
    //     None => {
    //         println!("ema_price ....... unavailable");
    //         println!("ema_conf ........ unavailable");
    //     }
    // }
}

// rustler::init!("Elixir.Pyth", [add]);
rustler::init!("Elixir.PythEx", [query]);
