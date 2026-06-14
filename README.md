# homebrew-tap

A [Homebrew](https://brew.sh) tap for [`parquet_viewer`](https://github.com/c256-labs/parquet_viewer) —
a k9s-style terminal UI for browsing Parquet files.

## Install

```bash
brew install c256-labs/tap/parquet_viewer
```

Or tap first, then install:

```bash
brew tap c256-labs/tap
brew install parquet_viewer
```

This pulls in `duckdb` from Homebrew and builds `parquet_viewer` from source
against it.

## Contents

- `Formula/parquet_viewer.rb` — the formula.
- `PUBLISHING.md` — how to cut a release and update the formula.

> The GitHub repo for this tap must be named `homebrew-tap` (the `homebrew-`
> prefix is required and dropped in the install command).
