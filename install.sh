#!/bin/bash

echo "Installing homedir dotfiles"

backup(){
    echo "making backup"
    CURDATE=`date +%Y_%m_%d_%H_%M_%S`
    BACKUPDIR=~/.backup/$CURDATE/
    echo "backing up to ${BACKUPDIR}"
    mkdir -p ${BACKUPDIR}
    
    for f in homedir/*; do
        name=$(basename $f)
        echo $name
        ls ~/.${name} 
        cp ~/.${name} ${BACKUPDIR}${name} 
    done
}

install() {
    echo "installing"
    for f in homedir/*; do
        name=$(basename $f)
        echo "copying ${f} to ~/.${name}"
        cp -v ${f} ~/.${name}
    done
}


backup
install
