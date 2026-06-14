# Homebrew formula for parquet_viewer.
#
# This file lives in the project repo for convenience, but Homebrew installs it
# from a *tap* repository. See PUBLISHING.md for how to publish it.
#
# Before the first release, fill in the release-specific placeholders below:
#   - the version tag in `url` (e.g. v0.1.0) once you push the git tag
#   - `sha256` : sha256 of the release tarball (see PUBLISHING.md step 4)
class ParquetViewer < Formula
  desc "k9s-style terminal UI for browsing Parquet files"
  homepage "https://github.com/c256-labs/parquet_viewer"
  url "https://github.com/c256-labs/parquet_viewer/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "069069e1523acb6b6f7b804ccecca8684f246d5cd85f18112cba1474fc485462"
  license "MIT"
  head "https://github.com/c256-labs/parquet_viewer.git", branch: "main"

  depends_on "duckdb"

  def install
    duckdb = Formula["duckdb"]
    system "make",
           "DUCKDB_INCLUDE=#{duckdb.opt_include}",
           "DUCKDB_LIB=#{duckdb.opt_lib}",
           "DUCKDB_RPATH=#{duckdb.opt_lib}"
    bin.install "build/parquet_viewer"
  end

  test do
    assert_match "usage", shell_output("#{bin}/parquet_viewer --help 2>&1")
  end
end
