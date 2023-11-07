# coinbase_stream

Listening and storing crypto order book data over websocket in Azure.

Connect to the Coinbase WebSocket API, record the top `N` price levels and volumes for given pairs, and optionally upload to Azure. See `python src/listen.py --help` for available options.
