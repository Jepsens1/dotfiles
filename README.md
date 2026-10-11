# Dotfiles

Arch + Hyprland config. Each top-level directory is a GNU Stow package. `install.sh` and `packages.txt` are not.

Put the repo at `~/dotfiles`.

## New machine

```bash
cd ~/dotfiles
stow */
./install.sh
```

`install.sh` asks for your password if `yay` is missing. Do not run it as root. It installs the packages, mise, and OpenCode, and enables `swaync` for the graphical session. Do not start Hyprland yet.

From the TTY, generate theme files before starting Hyprland. `install.sh` does not. Hyprland will not start without `~/.config/hypr/custom/colors.lua`.

```bash
matugen image ~/.local/share/wallpapers/tokyo-night-moon/arch.png
```

Any image works. Post-hooks may fail in the TTY. That is fine if `colors.lua` was written.

`ufw` is installed and not enabled. Enable it on a machine you own. Skip that on a work network that already has firewall rules.

## Current machine

`hyprland.lua` and `hyprlock.conf` use monitor `HDMI-A-2` and keyboard layout `dk`. Change those if this PC is different. `hyprctl monitors` prints the output name.

## After install

Firefox colors need the Pywalfox add-on. The native app comes from mise.

1. Install [Pywalfox](https://addons.mozilla.org/firefox/addon/pywalfox/).
2. From a shell where mise is active, run `pywalfox install`.
3. Restart Firefox and fetch colors.

## Stow again

From `~/dotfiles`, after you add a file to a package:

```bash
stow -R */
```

`-R` replaces the old links. Do not use `--adopt` unless you mean to pull a home file into the repo.
