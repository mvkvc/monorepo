# Goals

This is a work in progress, but the following features are planned in the approximate order of priority:

- [ ] Extract tagged code blocks in Livebooks to source files.
- [ ] Create new tags with custom paths to extract code to or change the default tag paths.
- [ ] Autogenerate and update a `index.livemd` file that lists every file in sorted order and is auto-linked to the bottom of every Livebook for easy navigation.
- [ ] Add `--sync` option to rebuild all the source files from Livebooks.
- [ ] The `--sync` option runs incrementally and only rebuilds source files from Livebooks that have changed or where the source file is missing.
- [ ] Two-way sync, including changes to source files being reflected in the associated Livebook so that team members are not forced to use Livebooks exclusively.
- [ ] Speed is an important consideration; the sync watcher should be fast enough not to hinder your workflow. Trying to keep this in Elixir only for now, but we may need to use Rust in the future.
