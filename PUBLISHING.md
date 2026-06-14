# Publishing `parquet_viewer` to Homebrew

**This file lives in the `homebrew-tap` repo** (alongside
`Formula/parquet_viewer.rb`). It documents how to publish the tool and this tap
so `parquet_viewer` becomes installable with:

```bash
brew install c256-labs/tap/parquet_viewer
```

It uses a **custom Homebrew tap** that builds from source against the
Homebrew-provided `duckdb` formula (no vendored binaries). Replace
`c256-labs` everywhere with your GitHub user or org.

---

## Overview

Two separate GitHub repos are involved:

1. **`parquet_viewer`** — the tool's source (`src/`, `Makefile`, `scripts/`, …).
2. **`homebrew-tap`** — *this* repo, the tap that hosts the formula. It **must**
   be named `homebrew-<something>`; the `homebrew-` prefix is dropped in the
   install command. With `homebrew-tap` the command is
   `brew install c256-labs/tap/parquet_viewer`.

```
parquet_viewer/                 # repo 1 — the tool (push to GitHub)
homebrew-tap/                   # repo 2 — this tap
  Formula/parquet_viewer.rb
  PUBLISHING.md                 # this file
  README.md
```

---

## 1. Add a LICENSE

The formula declares `license "MIT"`. Add a matching `LICENSE` file to the
**`parquet_viewer`** repo root (or change the formula's license line to whatever
you choose).

---

## 2. Publish the source repo

From the **`parquet_viewer`** project root:

```bash
git init
git branch -M main
git add Makefile CMakeLists.txt README.md LICENSE .gitignore \
        src scripts tests .github
# (build/ and third_party/duckdb/ are gitignored)
git commit -m "Initial public release"

# create the repo on GitHub first (gh, or the web UI), then:
git remote add origin https://github.com/c256-labs/parquet_viewer.git
git push -u origin main
```

With the GitHub CLI you can create + push in one step:

```bash
gh repo create c256-labs/parquet_viewer --public --source . --push
```

---

## 3. Tag a release

Homebrew downloads a versioned source tarball. Create and push a tag; GitHub
generates the tarball automatically at
`https://github.com/c256-labs/parquet_viewer/archive/refs/tags/<tag>.tar.gz`.

```bash
git tag v0.1.0
git push origin v0.1.0
```

---

## 4. Compute the tarball sha256

```bash
curl -L https://github.com/c256-labs/parquet_viewer/archive/refs/tags/v0.1.0.tar.gz \
  | shasum -a 256
```

Copy the hash.

---

## 5. Publish this tap repo

This repo already contains `Formula/parquet_viewer.rb`. Edit it and fill in:

- `homepage` and `url` → your `c256-labs`
- `url` version tag → `v0.1.0`
- `sha256` → the hash from step 4

Then publish from this (`homebrew-tap`) directory:

```bash
git init && git branch -M main
git add Formula/parquet_viewer.rb PUBLISHING.md README.md LICENSE .gitignore
git commit -m "parquet_viewer 0.1.0"
gh repo create c256-labs/homebrew-tap --public --source . --push
# or: git remote add origin https://github.com/c256-labs/homebrew-tap.git \
#     && git push -u origin main
```

---

## 6. Install and verify

```bash
brew tap c256-labs/tap
brew install c256-labs/tap/parquet_viewer
parquet_viewer --help
```

Recommended sanity checks before announcing:

```bash
brew audit --strict --online c256-labs/tap/parquet_viewer
brew test c256-labs/tap/parquet_viewer
```

To test the formula locally before tagging, point `url` at a local path or use:

```bash
brew install --build-from-source ./Formula/parquet_viewer.rb
```

---

## 7. Shipping new versions

1. Commit changes in `parquet_viewer`, tag a new version (e.g. `v0.2.0`), push the tag.
2. Recompute the sha256 (step 4) for the new tarball.
3. In `homebrew-tap`, bump `url` (version) and `sha256`, commit, push.
4. Users upgrade with `brew update && brew upgrade parquet_viewer`.

---

## Notes

- The formula links against Homebrew's `duckdb` via
  `DUCKDB_INCLUDE`/`DUCKDB_LIB`/`DUCKDB_RPATH` (passed to `make`), so the vendored
  `third_party/duckdb/` is **not** used in the brew build.
- `brew install` compiles the `src/` modules from source — fast, but a C
  compiler (Xcode Command Line Tools on macOS) is required, which brew ensures.
- Getting into `homebrew-core` (so plain `brew install parquet_viewer` works
  without a tap) requires notability and a stricter review; the custom tap is
  the practical path for a new tool.
