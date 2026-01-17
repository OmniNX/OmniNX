#!/bin/bash

# Build script for all OmniNX pack variants
# Usage: ./build-all.sh [version]

set -e

VERSION="${1:-1.0.0}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="$REPO_ROOT/output"

echo "Building all OmniNX pack variants $VERSION..."
echo ""

# Clean output directory before building all variants
if [ -d "$OUTPUT_DIR" ]; then
    echo "Cleaning output directory..."
    rm -f "$OUTPUT_DIR"/*.zip
    echo ""
fi

for variant in standard light oc; do
    echo "========================================="
    "$SCRIPT_DIR/build-pack.sh" "$variant" "$VERSION"
    echo ""
done

echo "========================================="
echo "All builds complete!"
echo ""
echo "Generated files:"
ls -lh "$OUTPUT_DIR"/*.zip 2>/dev/null || echo "No ZIP files found"
