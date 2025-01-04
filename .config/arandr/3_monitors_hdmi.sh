#!/bin/sh

xrandr --output eDP-1  --mode 1920x1080 --pos 0x270     --rotate normal           \
       --output HDMI-2 --mode 3840x2160 --pos 1920x0    --rotate normal --primary \
       --output HDMI-1 --mode 1920x1080 --pos 5760x-120 --rotate left   --rate 75 \
       --output DP-1 --off
