#!/usr/bin/env sh

username=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1)

echo "$username" | xclip -selection clipboard

notify-send "Create random username" "Username was created and copied in clipboard"
