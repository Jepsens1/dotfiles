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

`swaync` config belongs in the `swaync` package. `swappy/.config/swaync` is empty; do not put files there.

## Themes

Two generators write the same paths above. Editing one does not update the other.

- Named theme: `theme-apply <id> [wallpaper]` reads `theme/.config/theme/themes/<id>/colors.toml` and `theme/.config/theme/templates/*.tpl`. Placeholders are `{{key}}` and `{{key_hex}}` (`#` stripped). `themes/<id>/ghostty` is copied as-is, not rendered.
- Matugen: `theme-apply matugen <image>` runs `matugen image --source-color-index 0`. Templates in `matugen/.config/matugen/templates/` use matugen syntax (`<* for *>`, `{{value.default.hex}}`, `{{value.default.hex_stripped}}`). Do not mix the two languages. `matugen` is not a `colors.toml` theme.

`hyprland.lua` does `require("custom.colors")` from the generated file, not from the repo. Hyprland will not start without it, and `install.sh` does not create it. It only reads `colors.primary` and `colors.outline_variant`. The named-theme Lua template sets those from `purple` and `border`. `hyprlock.conf` sources the generated conf and expects `$primary`, `$secondary`, `$error`, `$on_surface`, `$inverse_on_surface`. Its background is the symlink `~/.cache/theme/current-wallpaper`.

Waybar, swaync, and walker CSS use Material names (`@surface`, `@primary`, `@on_surface`, `mod_*`), not `colors.toml` keys. Named themes map those names in `colors.css.tpl`. A new CSS color must be added to both CSS templates. Import paths differ (`colors/custom.css`, `colors/colors.css`, `colors.css`); do not unify them. Walker's committed theme is `theme = "custom"`. Ghostty's committed config is only `config-file = colors`; do not put a palette there.

Elephant scans only the stowed path `~/.config/theme/themes/*/colors.toml`. `theme-apply` can fall back to the repo; the menus cannot. Wallpaper images must be at the top of `~/.local/share/wallpapers/<id>/` (png/jpg/jpeg/webp). The repo's `matugen` wallpaper directory is empty. Other folders there (Graphite*) are not in this repo and are not menu entries.

Committed GTK `settings.ini` is the boot default (`adw-gtk3-dark`). `theme-apply` switches light/dark with `gsettings`, not by editing those files. `gtk/.local/share/icons/default/index.theme` is written by nwg-look; do not edit it. Cursor files under `bibata/` are the vendored Bibata-Modern-Ice theme.

Starship uses ANSI names in `starship.toml`. It is not part of either theme pipeline. Neovim's colorscheme is tokyonight `style = "moon"` and is not driven by `theme-apply`.

## Hyprland

Config is `hypr/.config/hypr/hyprland.lua` (`hl.*`), not `hyprland.conf`. Do not add one. LSP stubs are `/usr/share/hypr/stubs` (`.luarc.json`). `hl` is injected by Hyprland. Reload with `hyprctl reload`.

`hypridle.conf` and the elephant power menu dispatch with `hyprctl dispatch 'hl.dsp....'`, not classic keywords (`dpms off`, `exit`).

Do not normalize this machine: monitor `HDMI-A-2` (including every `monitor =` in `hyprlock.conf`), mode `3840x2160@240`, scale `1.25`, `kb_layout = "dk"`. `hyprctl monitors` prints the output name. hyprlock fonts are SF Pro (`apple-fonts`). The avatar is `hypr/.face.icon`, stowed to `~/.face.icon`.

## Packages and shell

System packages, official and AUR, are one name per line in `packages.txt` (`yay -S --needed - < packages.txt`). Do not re-run `install.sh` to apply config edits, and do not run it as root. `ufw` is installed and not enabled; do not enable it.

`pywalfox` is `pypi:pywalfox` in `mise/.config/mise/config.toml`, not an Arch package. The matugen post-hook calls `$HOME/.local/share/mise/shims/pywalfox`. Do not drop `--shims` from the zsh `mise activate` line. zsh plugins are sourced from `/usr/share/zsh/plugins/`, not oh-my-zsh.

## Neovim

lazy.nvim. Plugin specs only in `nvim/.config/nvim/lua/plugins/`. `lazy-lock.json` is committed. `init.lua` requires `config.keymaps`; that file is empty on purpose. Leader is space. `telescope-fzf-native` builds with `make`.

## Reload

- Hyprland: `hyprctl reload`
- Waybar CSS: `pkill -SIGUSR2 waybar`. Full restart: `~/.config/waybar/scripts/launch.sh` (also reloads swaync). Super+R runs that script.
- Waybar update count: `pkill -SIGRTMIN+8 waybar`
- swaync: `swaync-client -rs`. `config.json` is strict JSON; `waybar/config.jsonc` allows comments.
- Ghostty: `pkill -SIGUSR2 ghostty`
- btop: `pkill -USR2 btop`
