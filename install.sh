#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# Installs yay if its not installed
if ! command -v yay >/dev/null; then
    sudo pacman -S --needed base-devel git
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    (cd "$tmp/yay" && makepkg -si)
    rm -rf "$tmp"
fi

yay -S --needed - <packages.txt

systemctl --user enable swaync.service \
    app-com.mitchellh.ghostty.service \
    hyprpolkitagent.service \
    hypridle.service \
    waybar.service

elephant service enable

curl -fsSL https://mise.run | sh
"$HOME/.local/bin/mise" install

curl -fsSL https://opencode.ai/v2/install | bash -s -- --no-modify-path
