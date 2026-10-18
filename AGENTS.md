# AGENTS.md

Arch + Hyprland dotfiles. Each top-level directory is a GNU Stow package; the tree inside mirrors `$HOME`. Install, restow, machine-specific monitor/keyboard, and adding a theme are in `README.md`. There is no build, test, lint, or CI.

## Stow

`install.sh`, `packages.txt`, `README.md`, and this file are not packages. Do not stow the repo root. From `~/dotfiles`, restow only the package you changed (`stow -R hypr`). Never `stow --adopt` unless you mean to pull a home file into the repo.

After `stow`, tracked files are symlinks into this repo, so editing them edits the live config. A new file is not linked until that package is restowed.

Generated files sit beside those symlinks in real directories. Do not add them to a package. Stow will conflict, or a symlink will make theme generation write into git:

- `~/.config/hypr/custom/colors.lua` and `colors.conf`
- `~/.config/waybar/colors/custom.css`
- `~/.config/ghostty/colors`
- `~/.config/walker/themes/custom/colors.css`
- `~/.config/swaync/colors/colors.css`
- `~/.config/gtk-3.0/colors.css` and `~/.config/gtk-4.0/colors.css`
- `~/.config/btop/themes/custom.theme`

`swaync` config belongs in the `swaync` package. `swappy/.config/swaync` is empty; do not put files there. There is no `wallpapers` package. Images live only at `~/.local/share/wallpapers/<id>/`.

## Themes

`theme-apply <id> [wallpaper]` is the only theme generator. It reads `theme/.config/theme/themes/<id>/colors.toml` and `theme/.config/theme/templates/*.tpl`. Placeholders are `{{key}}` and `{{key_hex}}` (`#` stripped). Non-hex keys (`name`, `mode`, `opencode`) must not appear in a template. `themes/<id>/ghostty` is copied as-is, not rendered. `themes/<id>/vscode.json` is `{ "name", "extension" }`; `theme-apply` sets `workbench.colorTheme` in VSCodium or Code and installs the extension if missing. `opencode` in `colors.toml` is a built-in OpenCode theme name written to `~/.config/opencode/cli.json`. Do not stow that file or VSCodium `settings.json`. Do not add a second generator.

`hyprland.lua` does `require("custom.colors")` from the generated file, not from the repo. Hyprland will not start without it, and `install.sh` does not create it. It only reads `colors.accent` and `colors.border`. The Lua template sets those as `0xff` plus stripped hex. `theme-apply` does not reload Hyprland. Do not set border colors with `hyprctl keyword`. Run `theme-apply` before `hyprctl reload` after changing those keys, or the generated file and `hyprland.lua` disagree. `hyprlock.conf` sources the generated conf at lock time and reads `$accent`, `$magenta`, `$red`, `$foreground`, and `$background_dark`. Its background is the symlink `~/.cache/theme/current-wallpaper`.

GTK light/dark reload is `theme/.config/theme/scripts/gtk-themes-reload.sh`. The hyprlock wallpaper symlink is `update-hyprlock-background.sh` in that same directory. `theme-apply` calls both. Keep those scripts.

Waybar, swaync, and walker CSS use `colors.toml` role names (`@background`, `@accent`, `@red`), not a theme's native names. `theme-apply` writes one `@define-color` per hex key and exits if a `REQUIRED_ROLES` key is missing or not `#RRGGBB`. `color0` through `color15` are required by `pywalfox.json.tpl`; copy them from that theme's official terminal file, do not rebuild them. There is no `colors.css.tpl`. A new bar color is a role key in every `colors.toml`, then `@that_key` in the stylesheet. Do not invent a hex or rename a role to a native name (`iris`, `mauve`). `gtk.css.tpl` is the only name translation: libadwaita names such as `accent_color` and `window_bg_color`. Import paths differ (`colors/custom.css`, `colors/colors.css`, `colors.css`); do not unify them. Walker's committed theme is `theme = "custom"`. Ghostty's committed config is only `config-file = colors`; do not put a palette there. Live `~/.config/btop/btop.conf` is not in the repo and already points at the generated theme. Do not add a `btop.conf` that selects a bundled theme.

Elephant scans only the stowed path `~/.config/theme/themes/*/colors.toml`. `theme-apply` can fall back to the repo; the menus cannot. Elephant loads menu Lua at startup. Restart it after editing `themes.lua` or `wallpapers.lua`. `Cache = false` does not reload those scripts. Wallpaper images must be at the top of `~/.local/share/wallpapers/<id>/` (png/jpg/jpeg/webp). The wallpaper `find` must keep `-H`; a symlink starting point is empty without it. Other folders there (Graphite*) are not in this repo and are not menu entries. The menu runs `~/.local/bin/theme-apply` only. Walker has `close_when_open = true`, so a second `walker` closes the open one. Do not add a second `walker -d` picker.

Committed GTK `settings.ini` is the boot default (`adw-gtk3-dark`). `theme-apply` switches light/dark with `gsettings`, not by editing those files. `gtk/.local/share/icons/default/index.theme` is written by nwg-look; do not edit it. Cursor files under `bibata/` are the vendored Bibata-Modern-Ice theme.

Starship uses ANSI names in `starship.toml`. It is not part of the theme pipeline. Neovim's colorscheme is tokyonight `style = "moon"` and is not driven by `theme-apply`.

## Hyprland

Config is `hypr/.config/hypr/hyprland.lua` (`hl.*`), not `hyprland.conf`. Do not add one. LSP stubs are `/usr/share/hypr/stubs` (`.luarc.json`). `hl` is injected by Hyprland. Reload with `hyprctl reload`.

`hypridle.conf` and the elephant power menu dispatch with `hyprctl dispatch 'hl.dsp....'`, not classic keywords (`dpms off`, `exit`). Hyprland's `PATH` does not include `~/.local/bin`. Binds must use a command from `/usr/bin` (`walker`) or a full path.

Do not normalize this machine: monitor `HDMI-A-2` (including every `monitor =` in `hyprlock.conf`), mode `3840x2160@240`, scale `1.25`, `kb_layout = "dk"`. `hyprctl monitors` prints the output name. hyprlock fonts are SF Pro (`apple-fonts`). The avatar is `hypr/.face.icon`, stowed to `~/.face.icon`.

## Packages and shell

System packages, official and AUR, are one name per line in `packages.txt` (`yay -S --needed - < packages.txt`). Do not re-run `install.sh` to apply config edits, and do not run it as root. `ufw` is installed and not enabled; do not enable it.

`pywalfox` is `pypi:pywalfox` in `mise/.config/mise/config.toml`, not an Arch package. `theme-apply` calls `$HOME/.local/share/mise/shims/pywalfox`. Do not drop `--shims` from the zsh `mise activate` line. zsh plugins are sourced from `/usr/share/zsh/plugins/`, not oh-my-zsh.

## Neovim

lazy.nvim. Plugin specs only in `nvim/.config/nvim/lua/plugins/`. `lazy-lock.json` is committed. `init.lua` requires `config.keymaps`; that file is empty on purpose. Leader is space. `telescope-fzf-native` builds with `make`.

## Reload

- Hyprland: `hyprctl reload`
- Waybar CSS: `pkill -SIGUSR2 waybar`. Full restart: `~/.config/waybar/scripts/launch.sh` (also reloads swaync). Super+R runs that script.
- Waybar update count: `pkill -SIGRTMIN+8 waybar`
- swaync: `swaync-client -rs`. `config.json` is strict JSON; `waybar/config.jsonc` allows comments.
- Ghostty: `pkill -SIGUSR2 ghostty`
- btop: `pkill -USR2 btop`
