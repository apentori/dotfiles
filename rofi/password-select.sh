#!/usr/bin/env bash

# Script to select a password from infra pass

SECRET=$(find .password-store -name "*.gpg" | sed 's|.password-store/||g' | sed 's|.gpg||g' | rofi -dmenu -p "Select Password" -display-columns)
pass $SECRET -c
