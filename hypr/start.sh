#!/usr/bin/env bash
#
swww init &
# setting wallpaper
swww img ~/Pictures/wallpaper/wave.png &

nm-applet --indicator &

# The bar
waybar &

# dunst
dunst

# Auth agent
polkit-kde-agent

swayosd-server

wl-paste --type text --watch cliphist store & #Stores only text data

wl-paste --type image --watch cliphist store & #Stores only image data
