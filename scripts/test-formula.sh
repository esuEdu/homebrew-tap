#!/bin/bash
# Installs the formula in this checkout through Homebrew, as a tap, then tests and
# audits it. Used by both workflows.
set -euo pipefail
here=$(cd "$(dirname "$0")/.." && pwd)
tap="$(brew --repository)/Library/Taps/esuedu/homebrew-tap"
mkdir -p "$(dirname "$tap")"
rm -rf "$tap"
ln -s "$here" "$tap"
brew install --build-from-source esuedu/tap/wraith
brew test esuedu/tap/wraith
brew audit --strict esuedu/tap/wraith
wraith version
