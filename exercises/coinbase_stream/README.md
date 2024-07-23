# coinbase_stream

Listening and storing blockchain order book data over websockets in Azure. Connects to the Coinbase WebSocket API, records the top `N` price levels and volumes for given pairs, and optionally uploasd to Azure. See `python src/listen.py --help` for available options.
