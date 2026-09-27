#!/usr/bin/env bash
set -euo pipefail

# Starship reads one file. The stowed layout stays free of generated colors.
# This appends ~/.config/starship/palettes.toml and writes the result outside the repo.
LAYOUT="${HOME}/.config/starship.toml"
PALETTE="${HOME}/.config/starship/palettes.toml"
OUT="${HOME}/.config/starship/config.toml"

if [[ ! -f "$PALETTE" ]]; then
  echo "starship palette not found: $PALETTE" >&2
  exit 1
fi

if [[ ! -f "$LAYOUT" ]]; then
  echo "starship config not found: $LAYOUT" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT")"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

{
  cat "$LAYOUT"
  printf '\n'
  cat "$PALETTE"
} > "$tmp"

cp "$tmp" "$OUT"
echo "wrote ${OUT}"
