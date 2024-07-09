# mvkvc

My personal monorepo.

To initialize external repositories in the [`vendor/`](./vendor) folder run: `git submodule update --init --recursive`.

## Projects

Here is a list of the projects complete enough to share:

<!--- makeme start --->
### `apps`

- [`bank_crawl`](./apps/bank_crawl/README.md)
  - **Description**: CLI to crawl central bank press releases.
  - **Tech**: Python, BeautifulSoup, Requests.

- [`exboost`](./apps/exboost/README.md)
  - **Description**: LLM question-answering engine.
  - **Tech**: Elixir, OpenAI API, Phoenix.

- [`site`](./apps/site/README.md)
  - **Description**: My personal website.
  - **Tech**: Next.js, React, Vercel.

- [`tcp_chat`](./apps/tcp_chat/README.md)
  - **Description**: TCP chat server.
  - **Tech**: Elixir, OTP.

### `config`

### `exercises`

- [`axon_examples`](./exercises/axon_examples/README.md)
  - **Description**: Examples illustrating the Axon neural network library.
  - **Tech**: Elixir, Axon, Nx.

- [`protohackers`](./exercises/protohackers/README.md)
  - **Description**: Server programming challenges.
  - **Tech**: Various (depending on the challenge).

### `libs`

- [`kino_fly`](./libs/ex/kino_fly/README.md)
  - **Description**: Livebook smart cell for the Fly.io machines API.
  - **Tech**: Elixir, Livebook, Fly.io API.

- [`kino_util`](./libs/ex/kino_util/README.md)
  - **Description**: Livebook smart cell to monitor system utilization.
  - **Tech**: Elixir, Livebook.

- [`portboy`](./libs/ex/portboy/README.md)
  - **Description**: Easily call other languages in Elixir with Ports.
  - **Tech**: Elixir.

- [`wandb_server_ex`](./libs/ex/wandb_server_ex/README.md)
  - **Description**: Local `wandb` server and Elixir client.
  - **Tech**: Elixir, Weights & Biases, Phoenix.

### `research`

### `talks`

- [`custom_smart_cells`](./talks/custom_smart_cells/README.md)
  - **Description**: Talk about building custom Livebook smart cells given at the Toronto Elixir meetup.

### `utils`

### `vendor`

- [`replicant`](./vendor/replicant/README.md)
  - **Description**: Decentralized local AI inference network.
  - **Tech**: Rust, WebAssembly, Tauri.
<!--- makeme end --->
