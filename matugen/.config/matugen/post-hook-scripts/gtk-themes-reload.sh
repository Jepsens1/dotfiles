#!/usr/bin/env bash
set -euo pipefail

mode="${1:-dark}"

if [[ "$mode" == "light" ]]; then
  theme="adw-gtk3"
  scheme="prefer-light"
  other_scheme="prefer-dark"
else
  theme="adw-gtk3-dark"
  scheme="prefer-dark"
  other_scheme="prefer-light"
fi

gsettings set org.gnome.desktop.interface gtk-theme ""
gsettings set org.gnome.desktop.interface gtk-theme "$theme"
gsettings set org.gnome.desktop.interface color-scheme "$other_scheme"
gsettings set org.gnome.desktop.interface color-scheme "$scheme"
