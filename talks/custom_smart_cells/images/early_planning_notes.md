Current best ideas

- system utilizaiton display cell
- fly io machines controller (deploy and see list of popular dockerized apps metabase as example !!)
- documentation lookup

Others

- postman similar to api
- discord message client
- get sports scores

**Cell 1 / Cell 1: Phase 1?**
*idea 1*
Slack message smart cell -> Discord message smart cell.
Debut live with a request for Livebook channel on Elixir Discord.
DISCORD TAKEN
Another messaging platform word be good or texts w/

**Cell 2 / Cell 1: Phase 2**
*idea 1*
fly.io machines controller: constant overview of server/app state
CPU UTIL

**Cell 3 / Cell 1: Phase 3**
*idea 1*
Elixir documentation lookup

- Download the entire elixir docs
- Chunk it by page or subpage based on length (diff chuncks of same page have same url)
- Embed it once with an ML model
- Upload to sqlite db or something on file
- In the smart cell
- User types a question or statement whatever
- Embed with same model that was used to generate doc embeddings client side
- Search for nearest N vectors in db/file
*IF THIS GETS TOO COMPLICATED WE CAN USE TEXT SEARCH*
Questions:
- What model are we going to use (good but small enough to run and download client side)?
  - BERT family of models, need to pick which one
  - ALBERT (A Lite BERT) which is great (this is smallest 50mb - larger 500MB-1GB)
- How to store the vectors sqlite vs file/csv and in memory?
  - SQLite requires extension to do
  - ExQlite supports loading extensions (and ex_sqlean can be our example)
  - BERT family of models, need to pick which one
  - ALBERT (A Lite BERT) which is great (this is smallest 50mb - larger 500MB-1GB)
  - Bumblebee has Bumblebee.Utils.Nx.cosine_similarity fn ??
  - Scholar has Scholar.Metrics.Distance ??
- How to store the vectors to sim search
- How to download vectors to local?
- How to do similarity search on sqlite?
  - sqlite_vss extension
  - potentially load with nif/rustler

*FUTURE PROJECT IDEA CREATE AN API*

Track CPU/MEM/GPU/GPUMEM usage in a Livebook branch

Example code

```bash
# !/bin/bash

while :
do

# Get the current usage of CPU, memory, and GPU

  cpuUsage=$(top -bn1 | awk '/Cpu/ { print 100 - \$8 "%"}')
  memUsage=$(free -m | awk '/Mem/{print \$3 " MB"}')
  gpuUsage=$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader | awk -F "," '{if(NR==1){used=\$1; total=\$2}} END {print "GPU Memory Usage: " used/total*100 "%"}')

# Print the usage

  echo "CPU Usage: $cpuUsage"
  echo "Memory Usage: $memUsage"
  echo "$gpuUsage"

# Sleep for 1 second

  sleep 1
done
```
