#!/bin/sh
set -e

echo ""
echo "======================================================================"
echo "  pfSense Compact-Custom Themes — Installer"
echo "  https://github.com/f-link4/pfsense-compact-custom-themes"
echo "======================================================================"

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

TMPDIR="/tmp/pfsense_compact_custom_themes"
mkdir -p "$TMPDIR"
cleanup() {
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

cd "$TMPDIR" || exit 1

BRANCH=main
for arg in "$@"; do
    case "$arg" in
        --*)  echo "Unknown option: $arg" >&2; exit 1 ;;
        *)    BRANCH="$arg" ;;
    esac
done

ARCHIVE="${BRANCH}.tar.gz"
DEST="/usr/local/www/css"

if [ -f "$ARCHIVE" ]; then
    echo "Using pre-loaded archive: $TMPDIR/$ARCHIVE"
else
    echo "Downloading themes from GitHub..."
    curl -sL -o "$ARCHIVE" "https://github.com/f-link4/pfsense-compact-custom-themes/archive/$ARCHIVE"
    if [ $? -ne 0 ] || [ ! -s "$ARCHIVE" ]; then
        echo "Failed to download from GitHub"
        exit 1
    fi
fi

tar -xzf "$ARCHIVE"

EXTRACTED_DIR=$(tar -tzf "$ARCHIVE" | head -1 | cut -f1 -d"/")
if [ -z "$EXTRACTED_DIR" ]; then
    echo "Failed to find extracted directory"
    exit 1
fi
cd "$EXTRACTED_DIR" || exit 1

COUNT=$(ls Compact-Custom-[0-9][0-9]-*.css 2>/dev/null | wc -l | tr -d ' ')
if [ "$COUNT" = "0" ]; then
    echo "ERROR: no theme files found in archive"
    exit 1
fi

echo ""
echo "Installing $COUNT themes to $DEST..."
mkdir -p "$DEST"
install -m 0644 -v Compact-Custom-[0-9][0-9]-*.css "$DEST/"

echo ""
echo "======================================================================"
echo "  Installed:  $COUNT themes in $DEST"
echo "  List:       ls $DEST/Compact-Custom-*.css"
echo "======================================================================"
