#!/bin/sh

xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output HDMI1 --off --output HDMI2 --off --output VIRTUAL1 --off
killall stalonetray 2>/dev/null ; stalonetray --geometry 2x3-0-0 > "${XDG_CACHE_HOME}/logs/stalonetray.log" 2>&1 &
