#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=`get_volume`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i audio-volume-high -t 1000 -r 2593 -u normal "    $bar"
}

case $1 in
    up)
	# Up the volume (+ 5%)
	pactl set-sink-volume @DEFAULT_SINK@ +5% > /dev/null
	if [ $(get_volume) -gt 100 ]; then
	    pactl set-sink-volume @DEFAULT_SINK@ 100% > /dev/null
	fi
	send_notification
	;;
    down)
	pactl set-sink-volume @DEFAULT_SINK@ -5% > /dev/null
	send_notification
	;;
esac
