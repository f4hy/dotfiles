#!/usr/bin/env bash

set -e
set -u

usage() {
    echo "usage: `basename $0` [noconfirm]"
    echo "    runs various linux system maintainance"
    echo "    Default to prompt for each update"
    echo "    If passed 'noconfirm' then perform all without prompting"
    exit
}

if [[ $# -gt 1 ]]; then
    usage
fi

if [[ $# -eq 0 ]]; then
    NOCONFIRM=0
else
    if [[ $1 == "noconfirm" ]]; then
        NOCONFIRM=1
    elif [[ $1 != "" ]]; then
        echo "argument '$1' not recognized"
        usage
    fi
fi

prompt(){

    if [[ $NOCONFIRM == 1 ]]; then
        REPLY='y'
    else
        read -p "$1" -n 1 -r
        echo ""
    fi
}

update_arch(){

    EXTRAFLAGS=""
    if [[ $NOCONFIRM == 1 ]]; then
        EXTRAFLAGS+="--noconfirm "
    fi

    if [ -f /etc/arch-release ]; then
        echo "arch system found, updating packages"
    else
        echo "Not an arch system"
        return
    fi

    yaourt -Syu --aur $EXTRAFLAGS
    prompt 'Would you like to update devel packages?'
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        yaourt -Syu --aur --devel $EXTRAFLAGS
    fi
    echo ""
    prompt "Clean up pacman?"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        yaourt -Sc $EXTRAFLAGS
        yaourt -C $EXTRAFLAGS
    fi

}

update_pips(){
    EXTRAFLAGS="-p "
    if [[ $NOCONFIRM == 1 ]]; then
        EXTRAFLAGS=""
    fi


    echo "The following are outdated in pip2:"
    OUTDATED=$(pip2 list --outdated)
    echo $OUTDATED
    if [[ $OUTDATED != "" ]]; then
        prompt "Would you like to update outdated pip2 installs ?"
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pip2 list --outdated | awk '{print $1}' | xargs -n1 $EXTRAFLAGS sudo pip2 install -U
        fi
    else
        echo "pip2 uptodate"
    fi

    echo "The following are outdated in pip3:"
    OUTDATED=$(pip3 list --outdated)
    echo $OUTDATED
    if [[ $OUTDATED != "" ]]; then
        prompt "Would you like to update outdated pip3 installs ?"
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pip3 list --outdated | awk '{print $1}' | xargs -n1 $EXTRAFLAGS sudo pip3 install -U
        fi
    else
        echo "pip3 uptodate"
    fi

}

update_locate(){
    prompt "Update locate DB?"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo updatedb
        echo "Updated locate DB"
    fi
}

update_gpgkeys(){

    echo "refreshing keys"
    gpg --refresh-keys
}

vacuum_journal(){

    prompt "Vacuum Systemd journal to only the last 2 weeks?"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo journalctl --vacuum-time=2weeks
    fi
}


remove_cruft(){

    prompt "empty .local/share/Trash?"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf ${HOME}/.local/share/Trash/*
    fi

    EMPTYFILES=$(find . -maxdepth 2 -type f -empty -ls)
    prompt "remove empty files (maxdepth 2) $EMPTYFILES \n"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        find . -maxdepth 2 -type f -empty -delete
    fi

    echo "finding *~ temp files"
    find $HOME -path ${HOME}/Dropbox/emacs.d/auto-save-list -prune -o -type f -name "*~" | while read tmpfile
    do
        echo "$tmpfile"
        ORIG=${tmpfile%\~}
        if [[ -e $ORIG ]]; then
            ls -axl --color=auto $tmpfile $ORIG
            #cmp --silent $tmpfile $ORIG && echo "tmp file same as original!!" && rm $tmpfile
            git diff $ORIG $tmpfile || echo "rm $tmpfile?"
            rm -i $tmpfile
        else
            echo "$ORIG file missing"
            cat "$tmpfile"
        fi
        #exit
    done
}

echo "Which task"
AUTOTASKS="update_arch update_locate update_pips update_gpgkeys vacuum_journal"
OTHERTASKS="remove_cruft"
select TASK in "all" $AUTOTASKS $OTHERTASKS "done"; do
    case $TASK in
        "all")
            for i in $AUTOTASKS; do
                $i
            done
            break
            ;;
        "done")
            break
            ;;
        *) echo "Running $TASK"
            $TASK
            echo "Done with $TASK"
            echo "Choose another or exit (ENTER to show options again)"
            ;;
    esac
done
