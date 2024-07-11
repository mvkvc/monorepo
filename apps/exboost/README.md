---
name: exboost
desc: LLM question-answering service with customizable contexts.
tech: Elixir, Phoenix, LiveView, TypeScript, NodeJS, Electron
---

# exboost

Exboost is a customizable question answering engine. Currently it allows you to use any custom LLM by adding OpenAI-compatible API credentials as well as a search provider for additional context. Longer-term goals in development include a desktop client to connect your local documents, an interface to select online sources to scrape for context, and an interface to select which groups of context to use per conversation.

The following search providers are supported:

- [Exa](https://exa.ai)
- [Serper](https://serper.dev)

OpenAI-compatible API credentials are required to be entered in your account settings and a search provider is highly recommended.

## Components

```bash
.
├── app # Main application
├── desktop # Desktop app to sync folders
└── sh # Shell scripts
```

## License

[MIT](./LICENSE.md)
