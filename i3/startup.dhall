let map = https://prelude.dhall-lang.org/List/map

let restart =
		λ(name : Text)
	  → λ(options : Text)
	  → "pkill ${name}; sleep 1.5 && ${name} ${options}"

let mkExec = ./exec.dhall

let mkAlways = λ(command : Text) → "exec_always --no-startup-id " ++ command

let execAlways =
	  [ "./.fehbg"
	  , restart "compton" ""
	  , restart "dunst" "-config ~/.config/dunst/dunstrc"
	  , restart "redshift-gtk" "-l 39.749668:-105.216019"
	  ]

let exec =
	  [ "nm-applet"
	  , "blueman-applet"
	  , "xrandr --output DP-0 --primary --mode 1920x1080 --rate 143.85"
	  , "pulseaudio -k"
	  , "setxkbmap 3l"
	  ]

in  { execAlways =
		map Text Text mkAlways execAlways
	, exec =
		map Text Text mkExec exec
	}