# coinbase_stream

Listening and storing blockchain order book data over websockets in Azure.

## Goals

Connect to the Coinbase WebSocket API, record the top `N` price levels and volumes for given pairs, and optionally upload to Azure. See `python src/listen.py --help` for available options.
