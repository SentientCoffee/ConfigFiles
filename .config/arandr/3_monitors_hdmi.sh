#!/bin/sh
xrandr --output eDP1 --mode 1920x1080 --pos 0x540 --rotate normal --output DP1 --off --output HDMI1 --mode 1920x1080 --rate 75 --pos 5760x120 --rotate left --output HDMI2 --primary --mode 3840x2160 --pos 1920x0 --rotate normal --dpi 163 --output VIRTUAL1 --off
killall stalonetray 2>/dev/null ; stalonetray --geometry 3x4+5636-0 --max-geometry 3x4 --icon-size 36 --slot-size 40 > "${XDG_CACHE_HOME}/logs/stalonetray.log" 2>&1 &
