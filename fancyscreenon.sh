#!/bin/bash



xrandr --newmode "3840x2160_30.00" 338.75 3840 4080 4488 5136 2160 2163 2168 2200 -hsync +vsync
xrandr --addmode DP-1 "3840x2160_30.00"
xrandr --output eDP-1 --auto --primary --output DP-1 --mode 3840x2160_30.00 --above eDP-1 --rate 30
