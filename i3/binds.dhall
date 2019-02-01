let mkExec = ./exec.dhall

let mod = "mod4"

let direction = { d : Text, a : Text }

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

let term = "termite"

let menu = "rofi"

let bindAny =
		λ(keys : { h : Text, t : List Text })
	  → λ(command : Text)
	  → ''
		bindsym ${List/fold
				  Text
				  keys.t
				  Text
				  (λ(a : Text) → λ(b : Text) → b ++ "+" ++ a)
				  keys.h} ${command}
		''

let bind = λ(key : Text) → bindAny { h = mod, t = [ key ] }

let eBind =
		λ(key : Text)
	  → λ(command : Text)
	  → bindAny { h = mod, t = [ key ] } (mkExec command)

let bindNoMod =
		λ(key : Text)
	  → λ(command : Text)
	  → bindAny { h = key, t = [] : List Text } (mkExec command)

let sBind = λ(key : Text) → bindAny { h = mod, t = [ key, "Shift" ] }

let eSBind =
		λ(key : Text)
	  → λ(command : Text)
	  → bindAny { h = mod, t = [ key, "Shift" ] } (mkExec command)

let mkWorkSpace =
		λ(bi : Text → Text → Text)
	  → λ(prefix : Text)
	  →   [ bi "0" "${prefix} 10" ]
		# List/fold
		  Text
		  [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
		  (List Text)
		  (λ(a : Text) → λ(b : List Text) → b # [ bi a "${prefix} ${a}" ])
		  ([] : List Text)

let mkDirectionGeneric =
		λ(bi : Text → Text → Text)
	  → λ(command : direction → Text)
	  → List/fold
		direction
		directions
		(List Text)
		(λ(a : direction) → λ(b : List Text) → b # [ bi a.d (command a) ])
		([] : List Text)

let mkDirection =
		λ(bi : Text → Text → Text)
	  → λ(command : Text)
	  → mkDirectionGeneric bi (λ(a : direction) → "${command} ${a.a}")

in  { moves =
		mkDirection bind "focus" # mkDirection sBind "move"
	, workspaces =
		  mkWorkSpace bind "workspace"
		# mkWorkSpace sBind "move container to workspace"
	, binds =
		[ eBind "Return" term
		, sBind "q" "kill"
		, eBind "d" "rofi -show drun"
		, eSBind "d" "rofi -show run"
		, eBind "equal" "dmenu -nf #93A1A1 -nb #02395A -sb #55AA06 -sf #fdf6e3"
		, sBind "c" "reload"
		, bind "r" "restart"
		, sBind "e" "exit"
		, bind "b" "splith"
		, bind "v" "splitv"
		, bind "s" "layout stacking"
		, bind "w" "layout tabbed"
		, bind "e" "layout toggle"
		, sBind "s" "sticky toggle"
		, bind "f" "fullscreen"
		, sBind "space" "floating toggle"
		, bind "space" "focus mode_toggle"
		, bind "a" "focus parent"
		, sBind "minus" "move scratchpad"
		, bind "minus" "scratchpad show"
		, sBind "r" "resize"
		, eBind "c" "scrot -s '%Y-%m-%d-%T.png' -e 'mv \$f /tmp'"
		, bindNoMod "XF86AudioRaiseVolume" "/home/jack/.config/i3/volume.sh up"
		, bindNoMod
		  "XF86AudioLowerVolume"
		  "/home/jack/.config/i3/volume.sh down"
		, bindNoMod "XF86AudioMute" "set-sink-mute toggle"
		, bindNoMod "XF86MonBrightnessUp" "brightnessctl s +5%"
		, bindNoMod "XF86MonBrightnessDown" "brightnessctl s 5%-"
		, bindNoMod "XF86AudioPlay" "playerctl play"
		, bindNoMod "XF86AudioPause" "playerctl pause"
		, bindNoMod "XF86AudioNext" "playerctl next"
		, bindNoMod "XF86AudioPrev" "playerctl previous"
		, bind "t" "[instance=\"metask\"] scratchpad show"
		]
	, resize =
		  mkDirectionGeneric bind (λ(_ : direction) → "width 10 px or 10 ppt")
		# [ bindNoMod "Return" "mode \"default\""
		  , bindNoMod "Escape" "mode \"default\""
		  ]
	}