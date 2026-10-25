# AGENTS.md

Arch/Hyprland dotfiles; each top-level directory is a GNU Stow package mirroring `$HOME`. Install, Neovim setup, and theme authoring are in `README.md`. There is no repo-wide build/test/lint/CI.

## Stow and setup

- From the repo root, restow only the changed package (for example, `stow -R hypr` or `stow -R uwsm`). Stowed files are live symlinks; restow after adding files. Never use `--adopt` unless intentionally importing a home file.
- Do not stow the repo root. `install.sh`, `packages.txt`, `README.md`, and `AGENTS.md` are not packages. `install.sh` installs packages, mise, OpenCode, enables the SwayNC, Ghostty, hyprpolkitagent, hypridle, and Waybar user services, and enables Elephant's user service; do not run for config edits or as root. It does not generate theme files: run `theme-apply <id>` to create `~/.config/hypr/custom/colors.lua` before Hyprland's first start.
- `packages.txt` is one system package per line (`yay -S --needed - < packages.txt`). `pywalfox` is mise-managed (`pypi:pywalfox`), not an Arch package. Cursor theme `Bibata-Modern-Ice` is vendored in `bibata/`, not a package; keep that name in both GTK `settings.ini` files and `gtk/.local/share/icons/default/index.theme`, and keep size `24` aligned with `XCURSOR_SIZE` / `HYPRCURSOR_SIZE`.
- Keep generated theme outputs out of packages: `~/.config/hypr/custom/{colors.lua,colors.conf}`, `~/.config/waybar/colors/custom.css`, `~/.config/ghostty/colors`, `~/.config/walker/themes/custom/colors.css`, `~/.config/swaync/colors/colors.css`, `~/.config/gtk-{3.0,4.0}/colors.css`, `~/.config/btop/themes/custom.theme`, `~/.cache/wal/colors.json`, and `~/.cache/theme/neovim-spec`.
- `theme-apply` may also update btop's `~/.config/btop/btop.conf` (`color_theme`), VSCodium/Code `settings.json`, and OpenCode `cli.json`/`tui.json`; these are user settings, not Stow files. SwayNC config belongs in `swaync/`; wallpaper images belong in `theme/.local/share/wallpapers/<id>/`.

## Themes

- `theme/.local/bin/theme-apply` is the only generator. It reads `theme/.config/theme/themes/<id>/colors.toml` and `theme/.config/theme/templates/*.tpl`; `{{key}}` requires `#RRGGBB`, `{{key_hex}}` strips `#`, and `name`, `mode`, `opencode` are metadata, not template colors. Optional `neovim.lua` is a lazy.nvim plugin spec; `theme-apply` records its path in `~/.cache/theme/neovim-spec`, and Neovim loads it on startup. An empty or missing pointer falls back to Tokyo Night. Follow `README.md` for adding themes; do not add another generator.
- Preserve shared semantic role names and official `color0`–`color15` values. Ghostty theme files are copied as-is. Keep CSS imports app-specific: Waybar uses `colors/custom.css`, SwayNC `colors/colors.css`, Walker `colors.css`; Walker's GTK aliases stay in committed `style.css`.
- `theme-apply` does not reload Hyprland. `hypr/.config/hypr/modules/decoration.lua` requires generated `custom.colors`; after changing palette `accent`/`border`, run `theme-apply <id>` before `hyprctl reload`. `hyprlock.conf` sources generated `colors.conf` and uses `~/.cache/theme/current-wallpaper`.
- Elephant's theme menu scans only stowed `~/.config/theme/themes/*/colors.toml` (unlike `theme-apply`, it has no repo fallback). Menu files assign globals (`Name`, `GetEntries`); they are not Lua modules and load when the user service starts. After adding themes or menu code, restow and `systemctl --user restart elephant.service`. The unit is created by `elephant service enable` at `~/.config/systemd/user/elephant.service`; do not Stow it.
- The wallpaper menu scans only direct image files; keep `find -H` so it works when the wallpaper root is a symlink. Resolve wallpaper paths before the hyprlock symlink. When editing `theme-apply`, keep its reloads (Waybar, SwayNC, Ghostty when a theme file is copied, `pkill -USR2 btop`, mise `pywalfox`), the GTK reload script, and the hyprlock-background script. GTK reload sets `gtk-theme` via gsettings to `adw-gtk3` or `adw-gtk3-dark` from `mode`.
- Walker's theme is `custom`. Keep the `menus:themes` and `menus:wallpapers` actions in `walker/.config/walker/config.toml`; that file is otherwise mostly upstream defaults.

## Hyprland

- The entrypoint is `hypr/.config/hypr/hyprland.lua` (Lua, not `hyprland.conf`); it requires `modules/`. `hl` is injected by Hyprland; LSP stubs are `/usr/share/hypr/stubs`.
- `modules/programs.lua` defines names used by `keybinds.lua` with Hyprland `global`; `local` does not cross `require`.
- Preserve this machine's monitor (`HDMI-A-2`, `3840x2160@240`, scale `1.25`) in `modules/monitors.lua` and every monitor line in `hyprlock.conf`; preserve `kb_layout = "dk"` in `modules/input.lua`. For UWSM-managed sessions, shared environment values (`XCURSOR_SIZE`, `LIBVA_DRIVER_NAME=nvidia`, `__GLX_VENDOR_LIBRARY_NAME=nvidia`, `ELECTRON_OZONE_PLATFORM_HINT=auto`) belong in `uwsm/.config/uwsm/env`; Hyprland-specific `HYPR*` and `AQ_*` values belong in `uwsm/.config/uwsm/env-hyprland`. Use `export KEY=value`. Plain Hyprland sessions do not load UWSM env files; keep a separate `hl.env` source only if intentionally supporting that session too. `AQ_DRM_DEVICES` is an opt-in GPU-selection override; its first listed device is primary.
- Do not start Waybar, SwayNC, hypridle, hyprpolkitagent, Elephant, or Ghostty from `autostart.lua`; those are user services. Autostart only runs `awww-daemon` and `walker --gapplication-service`; keep both. Ghostty's unit is single-instance with no initial window: binds use `ghostty +new-window`, Elephant's `terminal_cmd` is `ghostty -e`.
- `hypridle.conf` uses `hyprctl dispatch 'hl.dsp....'`, not classic keywords. The Elephant power menu's UWSM logout action uses `uwsm stop` directly, not through `hyprctl dispatch`. Hyprland's `PATH` lacks `~/.local/bin`; binds need `/usr/bin` commands or full paths.
- hyprlock grace belongs only on the keybind (`hyprlock --grace 3` in `programs.lua`). Do not put `grace` back in `hyprlock.conf`; idle and the power-menu lock should lock immediately. The avatar is `hypr/.face.icon`, which stows to `~/.face.icon`. Keep `misc.force_default_wallpaper = 0`; awww owns the wallpaper.
- Ghostty owns opacity via `background-opacity`; keep the `windows.lua` opacity override for class `com.mitchellh.ghostty` so Hyprland's inactive opacity does not stack.

## Reload and shell

- Waybar module bodies are in `waybar/.config/waybar/modules/*.jsonc`; `config.jsonc` is layout/includes. Waybar config is JSONC; `swaync/.config/swaync/config.json` is strict JSON.
- Reloads: Hyprland `hyprctl reload`; Waybar `systemctl --user reload waybar.service` (full restart: `~/.config/waybar/scripts/launch.sh`, which also reloads SwayNC); SwayNC `systemctl --user reload swaync.service`; Ghostty `systemctl --user reload app-com.mitchellh.ghostty.service`; btop `pkill -USR2 btop`.
- Keep `mise activate zsh --shims`; zsh plugins are sourced from `/usr/share/zsh/plugins/`. `theme-apply` invokes `$HOME/.local/share/mise/shims/pywalfox`.
