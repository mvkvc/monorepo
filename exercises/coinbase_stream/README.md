---
name: coinbase_stream
desc: Recording order book data in Azure to query with Databricks.
tech: Python, Spark, Azure, Databricks 
---

# coinbase_stream

Listening and storing blockchain order book data over websockets in Azure. Connects to the Coinbase WebSocket API, records the top `N` price levels and volumes for given pairs, and optionally uploasd to Azure. See `python src/listen.py --help` for available options.
