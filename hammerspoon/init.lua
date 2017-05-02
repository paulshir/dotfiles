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

-- Alert Style --
for k,v in pairs(alert_style) do
	hs.alert.defaultStyle[k] = v;
end

-- Reload Config --
hs.hotkey.bind(hyper, 'r', function()
	hs.reload()
end)

-- karabiner workarounds, will move this functionality to karabiner once complex modifications has landed --
-- karabiner hyper workaround --
if isSierra then
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

-- karabiner fn workaround --
if isSierra then
	replace_fn_key = function(event, from, to)
		if event:getFlags()["fn"] and event:getKeyCode() == hs.keycodes.map[from] then
			event:setKeyCode(hs.keycodes.map[to])
		end
	end

	local fn_grab = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
		-- print(hs.keycodes.map[event:getKeyCode()])
		-- print(hs.inspect(event:getFlags()))
	    replace_fn_key(event, "h", "left")
	    replace_fn_key(event, "j", "down")
	    replace_fn_key(event, "k", "up")
	    replace_fn_key(event, "l", "right")
        
		-- These don't really work that well but leaving here anyway --'
		replace_fn_key(event, "1", "f1")
		replace_fn_key(event, "2", "f2")
		replace_fn_key(event, "3", "f3")
		replace_fn_key(event, "4", "f4")
		replace_fn_key(event, "5", "f5")
		replace_fn_key(event, "6", "f6")
		replace_fn_key(event, "7", "f7")
		replace_fn_key(event, "8", "f8")
		replace_fn_key(event, "9", "f9")
		replace_fn_key(event, "0", "f10")
		replace_fn_key(event, "-", "f11")
		replace_fn_key(event, "=", "f12")
		return false
	end):start()
end

-- karabienr ctrl standalone escape workaround --
if isSierra then
	local ctrl_modifier_state = 0 -- 0: clear, 1: ctrl, 2: any other key
	local ctrl_key_up = hs.eventtap.new({hs.eventtap.event.types.keyUp}, function(event) 
		if not event:getFlags():containExactly({}) then
			ctrl_modifier_state = 2
		end
	end):start()

	local ctrl_flags_changed = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
		if ctrl_modifier_state == 0 and event:getFlags():containExactly({"ctrl"}) then
			ctrl_modifier_state = 1
		elseif ctrl_modifier_state == 1 and event:getFlags():containExactly({}) then
			hs.eventtap.keyStroke({}, "escape")
		elseif event:getFlags():containExactly({}) then
			ctrl_modifier_state = 0
		else
			ctrl_modifier_state = 2
		end
	end):start()
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