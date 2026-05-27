#!/usr/bin/env bash

set -euo pipefail

# =========================
# Extension Versions
# =========================
VSCODE_MAVEN_VERSION="0.45.3"
VSCODE_JAVA_TEST_VERSION="0.45.0"
VSCODE_JAVA_DEPENDENCY_VERSION="0.27.3"
VSCODE_GRADLE_VERSION="3.17.3"
VSCODE_JAVA_DEBUG_VERSION="0.59.0"

install_extension() {
    local publisher="$1"
    local extension="$2"
    local version="$3"

    local file="${extension}.vsix"
    local url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher}/vsextensions/${extension}/${version}/vspackage"

    # Refuse non-HTTPS URLs
    [[ "$url" =~ ^https:// ]] || {
        echo "ERROR: URL must use HTTPS: $url" >&2
        exit 1
    }

    wget \
        --https-only \
        --secure-protocol=TLSv1_2 \
        -O "${file}" \
        "$url"

    mv "${file}" "${file}.gz"
    gunzip "${file}.gz"

    code-server --install-extension "${file}" --force
}

install_extension "vscjava" "vscode-maven" "$VSCODE_MAVEN_VERSION"
install_extension "vscjava" "vscode-java-test" "$VSCODE_JAVA_TEST_VERSION"
install_extension "vscjava" "vscode-java-dependency" "$VSCODE_JAVA_DEPENDENCY_VERSION"
install_extension "vscjava" "vscode-gradle" "$VSCODE_GRADLE_VERSION"
install_extension "vscjava" "vscode-java-debug" "$VSCODE_JAVA_DEBUG_VERSION"

echo "All extensions installed successfully."