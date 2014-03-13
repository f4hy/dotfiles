#!/bin/bash

RSYNCOPTS="-c --info=NAME2"

GITCLEAN=$(git diff --exit-code)
if [[ -z $GITCLEAN ]]; then
    echo "Git repo is clean, copying current dotfiles to repo"
else
    echo "Git is not clean"
    exit
fi

copy_homedir() {
    echo "copying"
    for f in homedir/*; do
        name=$(basename $f)
        rsync $RSYNCOPTS ~/.${name} ${f}
    done
}

copy_folder() {
    FOLDER=$1
    echo "copying ${FOLDER}"
    for f in ${FOLDER}/*; do
        name=$(basename $f)
        rsync $RSYNCOPTS ~/.${FOLDER}/${name} ${f}
    done
}


copy_homedir
copy_folder "i3"
copy_folder "ssh"
