#!/bin/sh
set -e

echo "======================================================================"
echo "  pfSense Compact-Custom Themes — Uninstaller"
echo "  https://github.com/f-link4/pfsense-compact-custom-themes"
echo "======================================================================"

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

DEST="/usr/local/www/css"
echo "Scanning $DEST..."

FILES=$(ls "$DEST"/Compact-Custom-[0-9][0-9]-*.css 2>/dev/null || true)
if [ -z "$FILES" ]; then
    echo "No Compact-Custom themes found in $DEST."
    echo "======================================================================"
    exit 0
fi

COUNT=$(echo "$FILES" | wc -l | tr -d ' ')
echo "Found $COUNT theme files."

echo "Removing files..."
for f in $FILES; do
    rm -fv "$f" || true
done

echo "======================================================================"
echo "  Removed:    $COUNT themes from $DEST"
echo "======================================================================"
