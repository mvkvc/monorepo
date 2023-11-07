# akashi

Decentralized working agreements.

## Links

- https://akashi.systems
- https://github.com/mvkvc/akashi
- https://github.com/users/mvkvc/projects/21

## Components

- `app/`: Main application.
- `contracts/`: Smart contracts.
- `libs/`: Shared libraries.
- `research/`: Incentive research.
- `site/`: Landing page, blog, and documentation.

## Development

### Requirements

- [Fly](https://fly.io/docs/hands-on/install-flyctl)
- [Doppler](https://docs.doppler.com/docs/install-cli)
- [Docker](https://docs.docker.com/get-docker/)
- [Nix](https://nixos.org/download.html) (w/ Nix [flakes](https://nixos.wiki/wiki/Flakes) enabled)

### Setup

- Run `doppler login` to authenticate.
- Run `sh/secrets.sh` to download secrets.
- Run `nix develop` to enter the project's Nix shell.
- Run `sh/setup.sh` to install dependencies.

### Commands

- Run tests: `earthly +test`.
- Build code: `earthly +build`.
- Build and push Docker images: `earthly +docker`.
- Start applications locally: `./sh/start.sh`.
