# bountisol

[![deploy_app](https://github.com/mvkvc/bountisol/actions/workflows/deploy_app.yml/badge.svg)](https://github.com/mvkvc/bountisol/actions/workflows/deploy_app.yml)
[![deploy_inference](https://github.com/mvkvc/bountisol/actions/workflows/deploy_inference.yml/badge.svg)](https://github.com/mvkvc/bountisol/actions/workflows/deploy_inference.yml)

Fully transparent on-chain bounties on Solana.

## Links

- https://bounti.sol
- https://bountisol.xyz

## Components

- `app/`: Full-stack web application.
- `programs/`: Solana programs.
- `sh/`: Shell scripts.

## Developing

### Requirements

- [Nix](https://nixos.org/download.html) (w/ [flakes](https://nixos.wiki/wiki/Flakes) enabled)

### Setup

- Copy `.env.*_` files to `.env.*` and fill in the values.
- Run `nix develop` to enter the Nix shell.
- Run `sh/setup.sh` to install dependencies.
