-- Typings --
-- hs.loadSpoon("EmmyLua")

-- Config --
local alert_style = {
	strokeColor = { white = 0, alpha = 0.75},
	strokeWidth = 0,
	textFont = "Hack",
	radius = 10
}

-- Constants --
local hyper = {"ctrl", "alt", "shift", "cmd"}

-- Alert Style --
for k,v in pairs(alert_style) do
	hs.alert.defaultStyle[k] = v;
end

-- Reload Config --
hs.hotkey.bind(hyper, 'r', function()
	hs.reload()
end)

hs.hotkey.bind(hyper, 'v', function()
	hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

hs.alert.show("HS Config Reloaded: " .. os.date("!%Y-%m-%dT%TZ"), 0.2)

