#!/bin/bash
scrot /tmp/screen_locked.png
convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked2.png
i3lock -e -f -i /tmp/screen_locked2.png
