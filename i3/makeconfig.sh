#!/bin/bash

if [ ! -f /$HOME/.i3/config.local ]; then
    echo "There is no .i3/config.local creating empty one"
    printf "## Local config\n\nset $DIRECTION right" > $HOME/.i3/config.local
fi

cat $HOME/.i3/config.base $HOME/.i3/config.local > $HOME/.i3/config
echo "i3 local and base merged"
