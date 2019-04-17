let mkExec = ./exec.dhall

let t = ./types.dhall

let ws = ./workspaces.dhall

let directions =
	  [ { d = "h", a = "left" }
	  , { d = "l", a = "right" }
	  , { d = "k", a = "up" }
	  , { d = "j", a = "down" }
	  , { d = "Left", a = "left" }
	  , { d = "Right", a = "right" }
	  , { d = "Up", a = "up" }
	  , { d = "Down", a = "down" }
	  ]

let b = ./bindFunc.dhall "mod4" directions

let metaBinds =
	  [ b.sBind "q" "kill"
	  , b.sBind "c" "reload"
	  , b.sBind "r" "restart"
	  , b.sBind "e" "exit"
	  , b.bind "f" "fullscreen"
	  , b.bind "r" "mode \"resize\""
	  ]

let layoutBinds =
	  [ b.bind "b" "splith"
	  , b.bind "v" "splitv"
	  , b.bind "s" "layout stacking"
	  , b.bind "w" "layout tabbed"
	  , b.bind "e" "layout toggle"
	  , b.sBind "s" "sticky toggle"
	  , b.bind "a" "focus parent"
	  , b.sBind "space" "floating toggle"
	  , b.bind "space" "focus mode_toggle"
	  , b.sBind "minus" "move scratchpad"
	  , b.bind "minus" "scratchpad show"
	  ]

let mediaBinds =
	  [ b.bindNoMod "XF86AudioRaiseVolume" "/home/jack/.config/i3/volume.sh up"
	  , b.bindNoMod
		"XF86AudioLowerVolume"
		"/home/jack/.config/i3/volume.sh down"
	  , b.bindNoMod "XF86AudioMute" "set-sink-mute toggle"
	  , b.bindNoMod "XF86MonBrightnessUp" "brightnessctl s +5%"
	  , b.bindNoMod "XF86MonBrightnessDown" "brightnessctl s 5%-"
	  , b.bindNoMod "XF86AudioPlay" "playerctl play"
	  , b.bindNoMod "XF86AudioPause" "playerctl pause"
	  , b.bindNoMod "XF86AudioNext" "playerctl next"
	  , b.bindNoMod "XF86AudioPrev" "playerctl previous"
	  ]

let appBinds =
	  [ b.eBind "Return" "termite"
	  , b.eBind "d" "rofi -show drun"
	  , b.eSBind "d" "rofi -show run"
	  , b.eBind "equal" "dmenu -nf #93A1A1 -nb #02395A -sb #55AA06 -sf #fdf6e3"
	  , b.eBind "c" "maim -s /tmp/$(date +%s).png"
	  , b.eBind "t" "tdrop -x 25% -w 50% -h 30% -a termite"
	  ]

in  { moves =
		b.mkDirection b.bind "focus" # b.mkDirection b.sBind "move"
	, workspaces =
		  ws.mkWorkSpace
		  b.bind
		  "workspace"
		  (ws.simpleWorkspaces # [ { k = "F4", w = "&#xf001;" } ])
		# ws.mkWorkSpace
		  b.sBind
		  "move container to workspace"
		  ws.simpleWorkspaces
	, metaBinds =
		metaBinds
	, layoutBinds =
		layoutBinds
	, mediaBinds =
		mediaBinds
	, appBinds =
		appBinds
	, binds =
		metaBinds # layoutBinds # mediaBinds # appBinds
	, resize =
		  b.mkDirectionGeneric
		  b.bind
		  (λ(_ : t.Direction) → "width 10 px or 10 ppt")
		# [ b.bind "Return" "mode \"default\""
		  , b.bind "Escape" "mode \"default\""
		  ]
	}
