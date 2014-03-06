#!/bin/bash

echo "Installing homedir dotfiles"
CURDATE=`date +%Y_%m_%d_%H_%M_%S`
BACKUPDIR=~/.backup/$CURDATE/

backup_homedir(){
    echo "making backup of homedir"
    echo "backing up to ${BACKUPDIR}"
    mkdir -p ${BACKUPDIR}

    for f in homedir/*; do
        name=$(basename $f)
        echo $name
        ls ~/.${name}
        cp ~/.${name} ${BACKUPDIR}${name}
    done
}

backup_ssh(){
    echo "making backup of ssh"
    echo "backing up to ${BACKUPDIR}ssh_"
    mkdir -p ${BACKUPDIR}
    for f in ssh/*; do
        name=$(basename $f)
        echo $name
        ls ~/.ssh/${name}
        cp ~/.ssh/${name} ${BACKUPDIR}ssh_${name}
    done
}

install_homedir() {
    echo "installing"
    for f in homedir/*; do
        name=$(basename $f)
        echo "copying ${f} to ~/.${name}"
        cp -v ${f} ~/.${name}
    done
}

install_ssh() {
    echo "installing"
    for f in ssh/*; do
        name=$(basename $f)
        echo "copying ${f} to ~/.ssh/${name}"
        cp -v ${f} ~/.ssh/${name}
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


backup_homedir
install_homedir
backup_ssh
install_ssh
setup_liquidprompt
