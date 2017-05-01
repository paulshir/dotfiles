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

-- Alert Style --
for k,v in pairs(alert_style) do
	hs.alert.defaultStyle[k] = v;
end

-- Reload Config --
hs.hotkey.bind(hyper, 'r', function()
	hs.reload()
end)

-- Hyper Workaround, will move this functionality to karabiner elements once complex modifications land --
if hs.host.operatingSystemVersion().major == 10 and hs.host.operatingSystemVersion().minor == 12 then
	local hyper_combos = "abcdefghijklmnopqrstuvwxyz0123456789"
	local hyper_combos_extra = {"left", "up", "down", "right", "return", "space", "tab", "delete"}
	local hyper_used = false;

	local f18_bind = hs.hotkey.modal.new({}, "f18")
	hyper_send = function(key)
		f18_bind:bind({}, key, function()
			hyper_used = true
			hs.eventtap.keyStroke(hyper, key)
		end)
	end

	hs.hotkey.bind({}, "f19", function()
		hyper_used = false
		f18_bind:enter()
	end, function()
		f18_bind:exit()
	end)

	backslash_bind = hs.hotkey.bind({}, "`", function()
		hyper_used = false
		f18_bind:enter()
	end, function()
		if not hyper_used then
			backslash_bind:disable()
			hs.eventtap.keyStroke({}, "`")
			backslash_bind:enable()
		end
		f18_bind:exit()
	end)

	for key in hyper_combos:gmatch"." do
		hyper_send(key)
	end

	for _, key in ipairs(hyper_combos_extra) do
		hyper_send(key)
	end
end

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
hs.alert.show("HS Config Reloaded", 0.2)