Name = "wallpapers"
NamePretty = "Wallpaper"
Icon = "preferences-desktop-wallpaper"
Parent = "themes"
FixedOrder = true
Cache = false
HideFromProviderlist = true

local home = os.getenv("HOME")
local wallpaper_root = home .. "/.local/share/wallpapers"
local apply_bin = home .. "/.local/bin/theme-apply"

local function quote(value)
	return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function apply_command(theme_id, path)
	return quote(apply_bin) .. " " .. quote(theme_id) .. " " .. quote(path)
end

function GetEntries()
	local theme_id = lastMenuValue("themes")
	if theme_id == nil or theme_id == "" then
		return {
			{ Text = "Pick a theme first", Value = "" },
		}
	end

	local entries = {}
	local handle = io.popen(
		"find -H "
			.. quote(wallpaper_root .. "/" .. theme_id)
			.. " -maxdepth 1 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \\) | sort"
	)
	if handle then
		for path in handle:lines() do
			local command = apply_command(theme_id, path)
			table.insert(entries, {
				Text = path:match("([^/]+)$"),
				Value = path,
				Preview = path,
				PreviewType = "file",
				Actions = {
					default = command,
					["menus:default"] = command,
				},
			})
		end
		handle:close()
	end

	if #entries == 0 then
		return {
			{
				Text = "No wallpapers",
				Subtext = wallpaper_root .. "/" .. theme_id,
				Value = "",
			},
		}
	end

	return entries
end
