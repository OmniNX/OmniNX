#!/bin/bash

# Build script for OmniNX pack variants
# Usage: ./build-pack.sh [standard|light|oc] [version]

set -e

VARIANT="${1:-standard}"
VERSION="${2:-1.0.0}"

if [[ ! "$VARIANT" =~ ^(standard|light|oc)$ ]]; then
    echo "Error: Variant must be 'standard', 'light', or 'oc'"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$REPO_ROOT/build"
OUTPUT_DIR="$REPO_ROOT/output"

# Capitalize variant name (portable)
case "$VARIANT" in
    standard) VARIANT_CAPITALIZED="Standard" ;;
    light) VARIANT_CAPITALIZED="Light" ;;
    oc) VARIANT_CAPITALIZED="OC" ;;
esac
PACK_NAME="OmniNX $VARIANT_CAPITALIZED"

echo "Building $PACK_NAME $VERSION..."

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/$PACK_NAME"

# Copy staging files (shared install-stage files) to root
echo "Copying staging files..."
cp -R "$REPO_ROOT/staging/"* "$BUILD_DIR/$PACK_NAME/"

# Create variant folder and copy variant-specific content into it
echo "Copying $VARIANT variant content..."
mkdir -p "$BUILD_DIR/$PACK_NAME/$PACK_NAME"
cp -R "$REPO_ROOT/$VARIANT/"* "$BUILD_DIR/$PACK_NAME/$PACK_NAME/"

# Update manifest.ini with version if it exists
MANIFEST_PATH="$BUILD_DIR/$PACK_NAME/$PACK_NAME/config/omninx/manifest.ini"
if [ -f "$MANIFEST_PATH" ]; then
    echo "Updating manifest.ini with version $VERSION..."
    sed -i.bak "s/^version=.*/version=$VERSION/" "$MANIFEST_PATH"
    rm -f "$MANIFEST_PATH.bak"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Create ZIP archive
ZIP_NAME="OmniNX-$VARIANT_CAPITALIZED-${VERSION}.zip"
ZIP_PATH="$OUTPUT_DIR/$ZIP_NAME"

# Clean up old version of this specific variant/version if it exists
if [ -f "$ZIP_PATH" ]; then
    echo "Removing existing $ZIP_NAME..."
    rm -f "$ZIP_PATH"
fi

echo "Creating ZIP archive: $ZIP_NAME..."
cd "$BUILD_DIR/$PACK_NAME"
zip -r "$ZIP_PATH" . > /dev/null

# Clean up build directory
rm -rf "$BUILD_DIR"

echo "Build complete: $ZIP_PATH"
echo "Pack size: $(du -h "$ZIP_PATH" | cut -f1)"
