#!/bin/bash

#########################################
# SHAMELESS RIPOFF FROM ANOTHER GUY LUL #
#########################################

pkill dunst
dunst -config ~/.config/dunst/dunstrc &

notify-send -u critical "CRITICAL LEVEL NOTIF."
notify-send -u normal "Normal level notif."
notify-send -u low "Low level notif."
notify-send "Song: " "$(MPD_HOST=127.0.0.1 mpc current)"


