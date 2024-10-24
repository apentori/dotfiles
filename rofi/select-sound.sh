#!/usr/bin/env bash


# Script to select sound output

SINK=$(pactl -f json list sinks | jq -r '.[].description' \
  | rofi -dmenu -p "select default Output" -display-columns)
echo "Sink description $SINK"
SINK_NAME=$(pactl -f json list sinks | jq -r ".[] | select(.description == \"$SINK\")| .name" )
echo "Sink Name: $SINK_NAME"

pactl set-default-sink $SINK_NAME
pactl move-sink-input $SINK_NAME
