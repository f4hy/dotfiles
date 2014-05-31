#!/bin/bash

windowname=$(xdotool getwindowfocus getwindowname)

num=$(i3-msg -t get_workspaces | python2 -c 'import sys, json; print next(i["num"] for i in json.load(sys.stdin) if i["focused"] == True)' )


i3-msg "rename workspace to ${num}:${windowname}"
