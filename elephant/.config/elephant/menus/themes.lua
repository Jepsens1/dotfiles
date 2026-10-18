Name = "themes"
NamePretty = "Themes"
Icon = "preferences-desktop-theme"
FixedOrder = true
Cache = false
HideFromProviderlist = true

local home = os.getenv("HOME")
local theme_root = home .. "/.config/theme/themes"

local function theme_label(dir, id)
	local file = io.open(dir .. "/colors.toml", "r")
	if not file then
		return id
	end
	local text = file:read("*a")
	file:close()
	return text:match('name%s*=%s*"([^"]+)"') or id
end

function GetEntries()
	local entries = {}
	local handle = io.popen("find " .. string.format("%q", theme_root) .. " -mindepth 2 -maxdepth 2 -name colors.toml | sort")
	if handle then
		for path in handle:lines() do
			local dir = path:match("(.+)/colors%.toml$")
			local id = dir:match("([^/]+)$")
			table.insert(entries, {
				Text = theme_label(dir, id),
				Value = id,
				Icon = "preferences-desktop-theme",
				SubMenu = "wallpapers",
			})
		end
		handle:close()
	end

	return entries
end
