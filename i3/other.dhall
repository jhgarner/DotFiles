let font = "pango:Source 10"

let mod = "mod4"

let floatMod = "floating_modifier ${mod}"

let window = "new_window pixel 0"

let fWindow =
		λ(title : Text)
	  → λ(action : Text)
	  → "for_window [class=\"${title}\"] ${action}"

let windowGuides =
	  [ fWindow "Triangle Example" "floating enable"
	  , fWindow "Spotify" "move container to workspace \"&#xf001;\""
	  ]

in  { font =
		font
	, floatMod =
		floatMod
	, window =
		window
	, windowGuides =
		windowGuides
	}