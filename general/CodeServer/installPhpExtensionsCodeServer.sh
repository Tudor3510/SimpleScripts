#!/usr/bin/env bash

set -e

EXTENSION="bmewburn.vscode-intelephense-client"

if ! command -v code-server >/dev/null 2>&1; then
    echo "ERROR: code-server not found."
    exit 1
fi

echo "Installing $EXTENSION..."

code-server --install-extension "$EXTENSION"

echo "Installed extensions:"
code-server --list-extensions | grep -i intelephense