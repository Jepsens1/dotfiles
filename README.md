# Dotfiles

Arch + Hyprland config. Each top-level directory is a GNU Stow package. `install.sh`, `packages.txt`, `README.md`, `THIRD_PARTY_NOTICES.md`, and `AGENTS.md` are not.

## New machine

```bash
sudo pacman -S --needed git stow
git clone https://github.com/Jepsens1/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow */
./install.sh
~/.local/bin/theme-apply tokyo-night
```

Git and Stow are bootstrapped first because they are needed to clone and stow the dotfiles; Stow is also listed in `packages.txt`. Run `install.sh` as your normal user, not as root. It asks for your password if `yay` is missing, installs the packages, mise, and OpenCode; enables the SwayNC, Ghostty, hyprpolkitagent, hypridle, and Waybar user services; enables Elephant's user service; and sets your login shell to Zsh with `chsh`. `chsh` may ask for your password, and the change takes effect on your next login.

The final command generates theme files from the TTY before you log in to Hyprland. `install.sh` does not generate them. Hyprland will not start without `~/.config/hypr/custom/colors.lua`.

A wallpaper is optional. GTK reload may fail in the TTY. That is fine if `colors.lua` was written.

## Hyprland session

UWSM is included in `packages.txt`; choose **Hyprland (uwsm-managed)** at login. SDDM is not installed or enabled by these dotfiles, so install and enable it separately if needed.

`ufw` is installed and not enabled. Enable it on a machine you own. Skip that on a work network that already has firewall rules.

## Current machine

`hyprland.lua` and `hyprlock.conf` use monitor `HDMI-A-2` and keyboard layout `dk`. Change those if this PC is different. `hyprctl monitors` prints the output name.

## Neovim

On first launch, lazy.nvim installs the configured plugins.

Mason automatically installs the configured LSP servers. Install Conform's formatters with:

```vim
:MasonInstall stylua ruff prettierd prettier clang-format csharpier shfmt
```

## Tmux

Install [TPM](https://github.com/tmux-plugins/tpm) and fetch the configured plugins (`prefix` + `I`, which is `Ctrl+S` then `Shift+I`):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Themes

Super+Shift+T opens the theme menu. Pick a theme, then a wallpaper from that theme only. A theme uses the palette in `theme/.config/theme/themes/<id>/colors.toml`.

To add a theme, copy `tokyo-night` and keep the same role keys. Change the hex values. Do not invent colors. Use that theme's published palette. Native names, such as `iris` or `mauve`, go in the comments, not in the keys. The wallpaper folder must have the same name:

```text
theme/.config/theme/themes/<id>/colors.toml
theme/.config/theme/themes/<id>/ghostty          # optional, official terminal theme
theme/.config/theme/themes/<id>/vscode.json      # optional, official editor theme
theme/.config/theme/themes/<id>/neovim.lua       # optional, lazy.nvim plugin spec
theme/.local/share/wallpapers/<id>/
```

`ghostty` is copied as-is. Leave it out only if the theme has no official Ghostty file. `color0` through `color15` in `colors.toml` should match that file. Firefox does not use that order. `pywalfox.json.tpl` puts `background`, `accent`, `magenta`, and `foreground` in the slots Pywalfox reads.

`vscode.json` names an editor theme and its extension. `theme-apply` installs the extension if it is missing and sets it in VSCodium. Set `opencode` in `colors.toml` to a built-in OpenCode theme name, such as `tokyonight`.

`neovim.lua` is a lazy.nvim plugin spec that sets the theme's colorscheme. `theme-apply` records its path in `~/.cache/theme/neovim-spec`; themes without one fall back to Tokyo Night. Restart Neovim after switching themes.

Restow after adding the files. Restart Elephant so it loads the new theme. Walker will not see it until then.

## After install

Firefox colors need the Pywalfox add-on. The native app comes from mise.

1. Install [Pywalfox](https://addons.mozilla.org/firefox/addon/pywalfox/).
2. From a shell where mise is active, run `pywalfox install`.
3. Restart Firefox and fetch colors.

## Stow again

From `~/dotfiles`, after you add a file to a package, restow only that package. For example:

```bash
stow -R hypr
```

`-R` replaces the old links. Do not use `--adopt` unless you mean to pull a home file into the repo.
