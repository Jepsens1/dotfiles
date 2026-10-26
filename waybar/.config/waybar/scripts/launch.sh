#!/usr/bin/env bash
set -euo pipefail

systemctl --user restart waybar.service
systemctl --user reload swaync.service
