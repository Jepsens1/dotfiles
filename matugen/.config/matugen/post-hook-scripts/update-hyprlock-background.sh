#!/usr/bin/env bash
set -euo pipefail

img="${1:-}"

# Fall back to what awww is currently displaying
if [ -z "$img" ]; then
    img="$(awww query 2>/dev/null | sed -n 's/.*currently displaying: image: //p' | head -n1)"
fi

# If awww isn't running (fresh boot), fall back to any image in Pictures
if [ -z "$img" ] && [ -d "$HOME/Pictures" ]; then
    img="$(find "$HOME/Pictures" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) 2>/dev/null | head -n1)"
fi

mkdir -p "$HOME/.cache/theme"
[ -n "$img" ] && ln -sfn "$img" "$HOME/.cache/theme/current-wallpaper"
