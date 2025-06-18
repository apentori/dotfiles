#!/usr/bin/env bash
#
# Auth agent
polkit-kde-agent

cliphist wipe

wl-paste --type text --watch cliphist store & #Stores only text data

hyprpanel &
