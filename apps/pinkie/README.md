# pinkie

<p align="center">
  <img src="assets/images/logo.png" alt="logo"/>
</p>

[![docs](https://github.com/mvkvc/pinkie/actions/workflows/docs.yaml/badge.svg?branch=main)](https://github.com/mvkvc/pinkie/actions/workflows/docs.yaml)
[![ci](https://github.com/mvkvc/pinkie/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/mvkvc/pinkie/actions/workflows/ci.yaml)

Self-hostable remote pinning service for IPFS.

**Note**: This project is currently under heavy development and is not recommended for use.

## Links

- [Website](https://pinkie.sh)
- [Documentation](https://docs.pinkie.sh)
- [Design](https://design.penpot.app/#/dashboard/team/840175e6-8ff7-812c-8001-bd704b31a464/projects/4b8a77a1-3fb4-8143-8002-150a705b8f49)

## Development

Make sure to have [Nix](https://nixos.org/download.html) installed before setting up your development environment. Next, navigate to the project root in a terminal and execute `nix develop --configure` to install all necessary dependencies and start a development shell. For subsequent sessions, you can directly enter the development shell by running `nix develop`. Alternatively, if you have `direnv` installed, after executing `direnv allow` once, the development shell will automatically start whenever you enter the project root.
