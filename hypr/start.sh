#!/usr/bin/env bash
#
swww init &
# setting wallpaper
swww img ~/Pictures/wallpaper/lonely_guy.jpg

nm-applet --indicator &

# The bar
waybar &

# Notification Daemon
swaync &

# Auth agent
polkit-kde-agent

swayosd-server

cliphist wipe

wl-paste --type text --watch cliphist store & #Stores only text data

