#!/usr/bin/env bash
#
# setting wallpaper
hyprpaper &
nm-applet --indicator &

# The bar
waybar &

# Notification Daemon
swaync &

# Auth agent
polkit-kde-agent

cliphist wipe

wl-paste --type text --watch cliphist store & #Stores only text data

