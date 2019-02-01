let transparent = "#02395AAA"

in  ''
	bar {
		i3bar_command i3bar -t
		position top
		tray_output primary
		status_command i3status-rs $HOME/.config/i3status/status.toml
		font pango:Source, DejaVu Sans Mono 10
		i3bar_command i3bar -t
		colors {
			   background ${transparent}
			   separator #aaaaaa
			   statusline #268bd2
			   focused_workspace #55AA06 #55AA06 #fdf6e3
			   active_workspace #fdf6e3 #6c71c4 #fdf6e3
			   inactive_workspace #647C85 #647C85 #fdf6e3
			   urgent_workspace #d33682 #d33682 #fdf6e3
		}
		mode hide
	}

	''