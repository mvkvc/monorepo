# bank_crawl

CLI to crawl central bank press releases.

Supported countries:

- [x] [Canada](https://www.bankofcanada.ca/press-releases/)
- [ ] [United Kingdom](https://www.bankofengland.co.uk/news/press-releases)
- [ ] [United States](https://www.federalreserve.gov/newsevents/pressreleases.htm)

## Usage

`./bank_crawl [CA UK US]`

### Developing

## Requirements

Other than Elixir this project relies on the Burrito library to package the application into a single executable. Review the Burrito [requirements](https://github.com/burrito-elixir/burrito#preparation-and-requirements) to ensure you can build the executable.

## Setup

Your OS should be detected automatically, but if not, you can set it manually in the `mix.exs` file in the `releases` section.

```bash
mix deps.get
./sh/build.sh
```
