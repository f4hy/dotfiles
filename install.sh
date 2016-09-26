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

backup_folder(){
    FOLDER=$1
    echo "making backup of ${FOLDER}"
    echo "backing up to ${BACKUPDIR}${FOLDER}_"
    mkdir -p ${BACKUPDIR}
    for f in ${FOLDER}/*; do
        name=$(basename $f)
        echo $name
        ls ~/.${FOLDER}/${name}
        cp ~/.${FOLDER}/${name} ${BACKUPDIR}${FOLDER}_${name}
    done
}

backup_nondotfolder(){
    FOLDER=$1
    echo "making backup of ${FOLDER}"
    echo "backing up to ${BACKUPDIR}${FOLDER}_"
    mkdir -p ${BACKUPDIR}
    for f in ${FOLDER}/*; do
        name=$(basename $f)
        echo $name
        ls ~/${FOLDER}/${name}
        cp ~/${FOLDER}/${name} ${BACKUPDIR}${FOLDER}_${name}
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

install_folder() {
    FOLDER=$1
    echo "installing ${FOLDER}"
    for f in ${FOLDER}/*; do
        name=$(basename $f)
        echo "copying ${f} to ~/.${FOLDER}/${name}"
        cp -v ${f} ~/.${FOLDER}/${name}
    done
}

install_nondotfolder() {
    FOLDER=$1
    echo "installing ${FOLDER}"
    for f in ${FOLDER}/*; do
        name=$(basename $f)
        echo "copying ${f} to ~/${FOLDER}/${name}"
        cp -u -v ${f} ~/${FOLDER}/${name}
    done
}

install_symlink() {
    FOLDER=$1
    echo "installing ${FOLDER}"
    for f in ${FOLDER}/*; do
        name=$(basename $f)
        echo "linking ${f} to ~/${FOLDER}/${name}"
        echo $(realpath $f)
        ln -s $(realpath $f) $HOME/${FOLDER}/${name}
    done
}


setup_liquidprompt(){
    if [ -d "$HOME/local/liquidprompt/" ]; then
        echo "$HOME/local/liquidprompt exists!"
        wylt="Would you like to"
        read -p "$wylt update the liquidprompt in ~/local ? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pushd ~/local/liquidprompt/
            git pull
            popd
        fi
    else
        read -p "$wylt install the liquidprompt to ~/local ? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p ~/local
            pushd ~/local
            git clone https://github.com/nojhan/liquidprompt.git
            popd
        fi
    fi
}

setup_i3() {
    $HOME/.i3/makeconfig.sh
}

setup_ssh() {
    chmod 600 ~/.ssh/*
}

backup_homedir
install_homedir
backup_folder "ssh"
install_folder "ssh"
backup_folder "i3"
install_folder "i3"
# backup_nondotfolder "bin"
# install_nondotfolder "bin"
install_symlink "bin"
setup_i3
setup_ssh
setup_liquidprompt
