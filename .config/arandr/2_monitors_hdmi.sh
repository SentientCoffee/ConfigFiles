#!/bin/sh

xrandr --output HDMI-2 --mode 3840x2160 --pos 0x0      --rotate normal --primary \
       --output HDMI-1 --mode 1920x1080 --pos 3840x120 --rotate left   --rate 75 \
       --output eDP-1  --off                                                     \
       --output DP-1   --off
