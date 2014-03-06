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

setup_liquidprompt(){
    if [ -d "$HOME/local/liquidprompt/" ]; then
        echo "$HOME/local/liquidprompt exists!"
        read -p "Would you like to update the liquidprompt in ~/local ? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            pushd ~/local/liquidprompt/
            git pull
            popd
        fi
    else
        read -p "Would you like to install the liquidprompt to ~/local ? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            mkdir -p ~/local
            pushd ~/local
            git clone https://github.com/nojhan/liquidprompt.git
            popd
        fi
    fi
}


backup
install
setup_liquidprompt
