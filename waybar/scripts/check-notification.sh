#!/usr/bin/env bash

# Script to show number of notification on the system

dunstctl history | jq '.data[0] | length'
