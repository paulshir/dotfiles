-- Config --
local alert_style = {
	strokeColor = { white = 0, alpha = 0.75},
	strokeWidth = 0,
	textFont = "Hack",
	radius = 10
}

local application_mode_shortcuts = {
	{shortcut = "c", app = "Google Chrome", alias = "Chrome"},
	{shortcut = "f", app = "Firefox"},
	{shortcut = "i", app = "Intellij IDEA CE", alias = "Intellij"},
	{shortcut = "m", app = "Spotify"},
	{shortcut = "s", app = "Sublime Text"},
	{shortcut = "t", app = "iTerm"},
	{shortcut = "v", app = "Visual Studio Code", alias = "VS Code"},
	{shortcut = "w", app = "WhatsApp"},
	{shortcut = "return", app = "Finder"},
}

-- Constants --
hyper = {"ctrl", "alt", "shift", "cmd"}
isSierra = hs.host.operatingSystemVersion().major == 10 and hs.host.operatingSystemVersion().minor == 12
isHighSierra = hs.host.operatingSystemVersion().major == 10 and hs.host.operatingSystemVersion().minor == 13
isMojave = hs.host.operatingSystemVersion().major == 10 and hs.host.operatingSystemVersion().minor == 14

-- Alert Style --
for k,v in pairs(alert_style) do
	hs.alert.defaultStyle[k] = v;
end

-- Reload Config --
hs.hotkey.bind(hyper, 'r', function()
	hs.reload()
end)

-- CMD+Q Safety --
local cmd_q_bind
local cmd_q_trigger
local cmd_q_key_down_time

function cmd_q_on_key_down()
	cmd_q_trigger = false
	cmd_q_key_down_time = hs.timer.secondsSinceEpoch()
end

function cmd_q_on_key_up()
	if cmd_q_trigger then
		cmd_q_bind:disable()
		hs.eventtap.keyStroke({"cmd"}, 'q')
		cmd_q_bind:enable()
	else
		hs.alert.show("⌘+Q Safety is on")
	end
end

function cmd_q_on_key_hold()
	if not cmd_q_trigger then
		local diff = hs.timer.secondsSinceEpoch() - cmd_q_key_down_time
		if diff >= 0.3 then
			cmd_q_trigger = true
		end
	end
end

cmd_q_bind = hs.hotkey.bind({"cmd"}, 'q', cmd_q_on_key_down, cmd_q_on_key_up, cmd_q_on_key_hold)

-- Lock Screen with ScreenSaver --
hs.hotkey.bind(hyper, 'l', function()
	if (isSierra) then
		os.execute("open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app")
	else
		os.execute("open -a /System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"); 
	end
end)

-- Application Mode --
local a_bind = hs.hotkey.modal.new(hyper, 'a', "Application Mode")
for i, v in ipairs(application_mode_shortcuts) do
	local title;
	if v.alias then title = v.alias else title = v.app end
	a_bind:bind({}, v.shortcut, title, function()
		hs.application.launchOrFocus(v.app)
		a_bind:exit()	
	end)
end

a_bind:bind({}, 'escape', "Application Mode Exited", function() a_bind:exit() end)
a_bind:bind(hyper, 'a', "Application Mode Exited", function() a_bind:exit() end)

-- Scratch --
hs.hotkey.bind(hyper, 's', function()
	hs.console.printStyledtext(hs.inspect(hs.window.orderedWindows()[1]:frame()))
end)

hs.alert.show("HS Config Reloaded", 0.2)