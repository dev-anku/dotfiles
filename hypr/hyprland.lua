-- MONITORS
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-- PROGRAMS
local terminal = "kitty"
local browser = "brave"
local fileManager = "thunar"

-- LAUNCHER
local launcher = "/usr/bin/vicinae"
local calc = launcher .. " vicinae://launch/calculator/history?toggle=true"
local runner = launcher .. " vicinae://launch/system/run?toggle=true"
local clipboard = launcher .. " vicinae://launch/clipboard/history?toggle=true"
local emoji = launcher .. " vicinae://launch/core/search-emojis"

-- VARIABLES
local wallpaper = "~/pictures/wallpapers/wallpaper.jpg"

-- AUTOSTART
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl -- user start hyprpolkitagent") -- required
	hl.exec_cmd("gammastep -l 26.9124:75.7873 -t 6500:3500 -b 1.0:0.8") -- night light
	hl.exec_cmd("flameshot")
	hl.exec_cmd("waybar")
	hl.exec_cmd("wbg " .. wallpaper)
	hl.exec_cmd("vicinae server")
end)

-- ENVIRONMENT VARIABLES
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- VISUAL SETTINGS
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,

		border_size = 2,

		col = {
			active_border = "rgba(ffffffee)",
			inactive_border = "rgba(595959aa)",
		},

		resize_on_border = false,
		allow_tearing = false,

		layout = "master",
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,

		-- active_opacity = 1.0,
		-- inactive_opacity = 1.0,
		--
		-- shadow = {
		-- 	enabled = true,
		-- 	range = 4,
		-- 	render_power = 3,
		-- 	color = "0xee1a1a1a",
		-- },

		blur = {
			enabled = true,
			size = 1,
			passes = 2,
			-- vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	master = {
		mfact = 0.5,
		new_status = "slave",
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,

		focus_on_activate = true,
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 0,

		sensitivity = -0.5,
		accel_profile = "flat",

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.3,
		},
	},

	group = {
		insert_after_current = false,

		groupbar = {
			font_size = 0,
			height = 0,
			indicator_height = 5,
			round_only_edges = false,
			rounding = 2,
			col = {
				active = "0xffffffff",
				inactive = "0x00000001",
			},
			gaps_in = 4,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- 3. Curves
local curves = {
	{ "linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } } },
	{ "md3_standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } } },
	{ "md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } } },
	{ "md3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } } },
	{ "overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.1 } } } },
	{ "crazyshot", { type = "bezier", points = { { 0.1, 1.5 }, { 0.76, 0.92 } } } },
	{ "hyprnostretch", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } } },
	{ "menu_decel", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } } },
	{ "menu_accel", { type = "bezier", points = { { 0.38, 0.04 }, { 1, 0.07 } } } },
	{ "easeInOutCirc", { type = "bezier", points = { { 0.85, 0 }, { 0.15, 1 } } } },
	{ "easeOutCirc", { type = "bezier", points = { { 0, 0.55 }, { 0.45, 1 } } } },
	{ "easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } } },
	{ "softAcDecel", { type = "bezier", points = { { 0.26, 0.26 }, { 0.15, 1 } } } },
	{ "md2", { type = "bezier", points = { { 0.4, 0 }, { 0.2, 1 } } } },
}

for _, curve in ipairs(curves) do
	hl.curve(curve[1], curve[2])
end

-- 4. Animations
local animations = {
	{ leaf = "windows", enabled = true, speed = 2, bezier = "md3_decel", style = "popin 60%" },
	{ leaf = "windowsIn", enabled = true, speed = 2, bezier = "md3_decel", style = "popin 60%" },
	{ leaf = "windowsOut", enabled = true, speed = 2, bezier = "md3_accel", style = "popin 60%" },
	{ leaf = "border", enabled = true, speed = 10, bezier = "default" },
	{ leaf = "fade", enabled = true, speed = 3, bezier = "md3_decel" },
	{ leaf = "layersIn", enabled = true, speed = 0.8, bezier = "menu_decel", style = "slide" },
	{ leaf = "layersOut", enabled = true, speed = 1.8, bezier = "menu_accel" },
	{ leaf = "fadeLayersIn", enabled = true, speed = 0.6, bezier = "menu_decel" },
	{ leaf = "fadeLayersOut", enabled = true, speed = 2.0, bezier = "menu_accel" },
	{ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "md3_decel", style = "slide" },
	{ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "md3_decel", style = "slidevert" },
}

for _, animation in ipairs(animations) do
	hl.animation(animation)
end

-- SMART GAPS
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
	name = "no-gaps-wtv1",
	match = { float = false, workspace = "w[tv1]" },
	border_size = 0,
	rounding = 0,
})
hl.window_rule({
	name = "no-gaps-f1",
	match = { float = false, workspace = "f[1]" },
	border_size = 0,
	rounding = 0,
})

-- KEYBINDINGS
local super = "SUPER"

hl.bind(super .. " + Q", hl.dsp.window.close())
hl.bind(super .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(super .. " + SHIFT + T", hl.dsp.exec_cmd(terminal))
hl.bind(super .. " + D", hl.dsp.exec_cmd(launcher .. " toggle"))
hl.bind(super .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(super .. " + SHIFT + B", hl.dsp.exec_cmd(browser .. " --incognito"))
hl.bind(super .. " + Escape", hl.dsp.exec_cmd("wlogout"))
hl.bind(super .. " + V", hl.dsp.exec_cmd(clipboard))
hl.bind(super .. " + R", hl.dsp.exec_cmd(runner))
hl.bind(super .. " + Period", hl.dsp.exec_cmd(emoji))
hl.bind("XF86Calculator", hl.dsp.exec_cmd(calc))
hl.bind(super .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(super .. " + G", hl.dsp.window.float({ action = "toggle" }))

hl.bind(super .. " + SHIFT + E", hl.dsp.exec_cmd("pkill waybar; waybar & pkill wbg"))
hl.bind(super .. " + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-invert.sh"))

-- Screenshot
hl.bind(super .. " + S", hl.dsp.exec_cmd("flameshot gui"))
hl.bind("Print", hl.dsp.exec_cmd("flameshot full --clipboard"))
hl.bind(super .. " + Print", hl.dsp.exec_cmd("flameshot full"))
hl.window_rule({
	name = "flameshot-floating",
	match = {
		class = "^(flameshot)$",
	},
	float = true,
})

-- Multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	super .. " + XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	super .. " + XF86AudioLowerVolume",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(super .. " + XF86AudioMute", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 1%"), { locked = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Move focus with Vim keys
hl.bind(super .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(super .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(super .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(super .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(super .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Move windows with SHIFT + Vim keys
hl.bind(super .. " + SHIFT + H", hl.dsp.window.move({ direction = "left", group_aware = true }))
hl.bind(super .. " + SHIFT + L", hl.dsp.window.move({ direction = "right", group_aware = true }))
hl.bind(super .. " + SHIFT + K", hl.dsp.window.move({ direction = "up", group_aware = true }))
hl.bind(super .. " + SHIFT + J", hl.dsp.window.move({ direction = "down", group_aware = true }))

-- Resize window with arrows
hl.bind(super .. " + left", hl.dsp.window.resize({ x = -50, y = 0 }))
hl.bind(super .. " + right", hl.dsp.window.resize({ x = 50, y = 0 }))
hl.bind(super .. " + up", hl.dsp.window.resize({ x = 0, y = -50 }))
hl.bind(super .. " + down", hl.dsp.window.resize({ x = 0, y = 50 }))

-- Group Keybinds
hl.bind(super .. " + W", hl.dsp.group.toggle())
hl.bind(super .. " + U", hl.dsp.group.prev())
hl.bind(super .. " + I", hl.dsp.group.next())
hl.bind(super .. " + SHIFT + U", hl.dsp.group.move_window({ forward = false }))
hl.bind(super .. " + SHIFT + I", hl.dsp.group.move_window({ forward = true }))

-- Workspace Keybinds
for i = 1, 10 do
	local key = i % 10
	hl.bind(super .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(super .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- NUMPAD Workspace
local numpadKeys = { "End", "Down", "Next", "Left", "Begin", "Right", "Home", "Up", "Prior", "Insert" }
for i = 1, 10 do
	hl.bind("KP_" .. numpadKeys[i], hl.dsp.focus({ workspace = i }))
end
hl.bind(" + KP_Insert", hl.dsp.exec_cmd("playerctl pause"))
hl.bind("ALT + TAB", hl.dsp.focus({ workspace = 10 }))
hl.bind("ALT + TAB", hl.dsp.exec_cmd("playerctl pause"))

-- Special Workspace
hl.bind(super .. " + Grave", hl.dsp.workspace.toggle_special("magic"))
hl.bind(super .. " + SHIFT + Grave", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with super + scroll
hl.bind(super .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(super .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with super + LMB/RMB and dragging
hl.bind(super .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(super .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Window Rules
local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
