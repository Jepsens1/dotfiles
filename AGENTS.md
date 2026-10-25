# AGENTS.md

Arch/Hyprland dotfiles; each top-level directory is a GNU Stow package mirroring `$HOME`. Install, Neovim setup, and theme authoring are in `README.md`. There is no repo-wide build/test/lint/CI.

## Stow and setup

- From the repo root, restow only the changed package (`stow -R hypr`). Stowed files are live symlinks; restow after adding files. Never use `--adopt` unless intentionally importing a home file.
- Do not stow the repo root. `install.sh`, `packages.txt`, `README.md`, and `AGENTS.md` are not packages. `install.sh` installs packages, mise, OpenCode, and enables swaync; do not run for config edits or as root.
- `packages.txt` is one system package per line (`yay -S --needed - < packages.txt`). `pywalfox` is mise-managed (`pypi:pywalfox`), not an Arch package.
- Keep generated theme outputs out of packages: `~/.config/hypr/custom/{colors.lua,colors.conf}`, `~/.config/waybar/colors/custom.css`, `~/.config/ghostty/colors`, `~/.config/walker/themes/custom/colors.css`, `~/.config/swaync/colors/colors.css`, `~/.config/gtk-3.0/colors.css`, `~/.config/gtk-4.0/colors.css`, and `~/.config/btop/themes/custom.theme`.
- `theme-apply` may also update btop's `~/.config/btop/btop.conf` (`color_theme`), VSCodium/Code `settings.json`, and OpenCode `cli.json`/`tui.json`; these are user settings, not Stow files. SwayNC config belongs in `swaync/`; wallpaper images belong in `theme/.local/share/wallpapers/<id>/`.

## Themes

- `theme/.local/bin/theme-apply` is the only generator. It reads `theme/.config/theme/themes/<id>/colors.toml` and `theme/.config/theme/templates/*.tpl`; `{{key}}` requires `#RRGGBB`, `{{key_hex}}` strips `#`, and `name`, `mode`, `opencode` are metadata, not template colors. Follow `README.md` for adding themes; do not add another generator.
- Preserve shared semantic role names and official `color0`–`color15` values. Ghostty theme files are copied as-is. Keep CSS imports app-specific: Waybar uses `colors/custom.css`, SwayNC `colors/colors.css`, Walker `colors.css`; Walker's GTK aliases stay in committed `style.css`.
- `theme-apply` does not reload Hyprland. `hypr/.config/hypr/modules/decoration.lua` requires generated `custom.colors`; after changing palette `accent`/`border`, run `theme-apply <id>` before `hyprctl reload`. `hyprlock.conf` sources generated `colors.conf` and uses `~/.cache/theme/current-wallpaper`.
- Elephant's theme menu scans only stowed `~/.config/theme/themes/*/colors.toml` (unlike `theme-apply`, it has no repo fallback); menu Lua loads at startup. After adding themes or menu code, restow the changed package and restart Elephant with `pkill elephant; elephant &`—it is launched by Hyprland, not systemd.
- The wallpaper menu scans only direct image files; keep `find -H` so it works when the wallpaper root is a symlink. `theme-apply` uses the GTK reload script and, when applying a wallpaper, the hyprlock-background script; keep both.

## Hyprland

- The entrypoint is `hypr/.config/hypr/hyprland.lua` (Lua, not `hyprland.conf`); it requires `modules/`. `hl` is injected by Hyprland; LSP stubs are `/usr/share/hypr/stubs`.
- `modules/programs.lua` defines names used by `keybinds.lua` with Hyprland `global`; `local` does not cross `require`.
- Preserve this machine's `HDMI-A-2`, `3840x2160@240`, scale `1.25`, `kb_layout = "dk"`, and Nvidia env vars (`LIBVA_DRIVER_NAME`, `__GLX_VENDOR_LIBRARY_NAME`, `ELECTRON_OZONE_PLATFORM_HINT`) in `modules/envs.lua` (including every monitor line in `hyprlock.conf`).
- `hypridle.conf` and the Elephant power menu use `hyprctl dispatch 'hl.dsp....'`, not classic keywords. Hyprland's `PATH` lacks `~/.local/bin`; binds need `/usr/bin` commands or full paths.
- Ghostty owns opacity via `background-opacity`; keep the `windows.lua` opacity override for class `com.mitchellh.ghostty` so Hyprland's inactive opacity does not stack.

## Reload and shell

- Waybar module bodies are in `waybar/.config/waybar/modules/*.jsonc`; `config.jsonc` is layout/includes. Waybar config is JSONC; `swaync/.config/swaync/config.json` is strict JSON.
- Reloads: Hyprland `hyprctl reload`; Waybar CSS `pkill -SIGUSR2 waybar` (full restart: `~/.config/waybar/scripts/launch.sh`, which also reloads swaync); SwayNC `swaync-client -rs`; Ghostty `pkill -SIGUSR2 ghostty`; btop `pkill -USR2 btop`.
- Keep `mise activate zsh --shims`; zsh plugins are sourced from `/usr/share/zsh/plugins/`. `theme-apply` invokes `$HOME/.local/share/mise/shims/pywalfox`.
