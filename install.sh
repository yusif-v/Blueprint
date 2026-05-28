#!/usr/bin/env bash
# Blueprint entrypoint. Detects the OS and dispatches to the matching script.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Darwin)
    echo "Detected OS: macOS"
    bash "$SCRIPT_DIR/scripts/macos.sh"
    ;;
  Linux)
    echo "Detected OS: Linux"
    bash "$SCRIPT_DIR/scripts/linux.sh"
    ;;
  *)
    echo "Unsupported OS: $(uname -s)"
    echo "On Windows, run scripts/windows.ps1 from PowerShell instead."
    exit 1
    ;;
esac
