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
theme-apply tokyo-night
```

A wallpaper is optional. GTK reload may fail in the TTY. That is fine if `colors.lua` was written.

`ufw` is installed and not enabled. Enable it on a machine you own. Skip that on a work network that already has firewall rules.

## Current machine

`hyprland.lua` and `hyprlock.conf` use monitor `HDMI-A-2` and keyboard layout `dk`. Change those if this PC is different. `hyprctl monitors` prints the output name.

## Themes

Super+T opens the theme menu. Pick a theme, then a wallpaper from that theme only. A theme uses the palette in `theme/.config/theme/themes/<id>/colors.toml`.

To add a theme, copy `tokyo-night` and change the hex values. Do not invent colors. Use that theme's published palette. The wallpaper folder must have the same name:

```text
theme/.config/theme/themes/<id>/colors.toml
theme/.config/theme/themes/<id>/ghostty          # optional, official terminal theme
theme/.config/theme/themes/<id>/vscode.json      # optional, official editor theme
wallpapers/.local/share/wallpapers/<id>/
```

`ghostty` is copied as-is. Leave it out only if the theme has no official Ghostty file. `color0` through `color15` in `colors.toml` should match that file, so Firefox and the terminal agree.

`vscode.json` names an editor theme and its extension. `theme-apply` installs the extension if it is missing and sets it in VSCodium. Set `opencode` in `colors.toml` to a built-in OpenCode theme name, such as `tokyonight`.

Restow after adding the files. Restart Elephant so it loads the new theme. Walker will not see it until then.

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
