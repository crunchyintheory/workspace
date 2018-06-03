#!/bin/zsh
# curl https://files.crunchyintheory.com/workspace.sh > workspace; mv workspace /usr/bin; chmod a+x /usr/bin/workspace

USR=~


if [ ! -d "$USR/.workspace/" ]; then
    echo "Workspace config directories not found...installing"
    mkdir "$USR/.workspace"
fi

if [ ! -f "$USR/.workspace/.zshrc" ]; then
    touch "$USR/.workspace/.zshrc"
    echo 'cd ~
if [ -f ~/.zshenv ]; then
    source ~/.zshenv
fi
if [ -f ~/.zshrc ]; then
    source ~/.zshrc
fi
cd $WORKSPACE
source $WORKSPACE/.workspace' > "$USR/.workspace/.zshrc"
fi

grepres=$(grep -E -o "^$1\ .+$" $USR/.workspace/known)

if [[ "$grepres" != "" ]]; then
    workspace ${grepres##"$1 "}
    exit
fi

if [[ "$1" == "-a" || "$1" == "--add" ]]; then
    if [ ! -f "$USR/.workspace/known" ]; then
        touch "$USR/.workspace/known"
    fi
    if cd "$2"; then
        d="$PWD"
        cd "$OLDPWD"
	    if [[ "$3" != "" ]]; then
       	    echo "$3 $d" >> "$USR/.workspace/known"
            echo "Saved workspace $3 as $d"
	    else
	        echo "Please provide a name for the workspace"
        fi
    else
        echo "No directory found at $2"
    fi
    exit
fi

if [[ "$WORKSPACE" != "" ]]; then
    echo "Netsting workspaces is not recommended."
fi

if [ ! -d $1 ]; then
    echo "Workspace not found"
    exit
fi

if [[ $1 == "" ]]; then
    1="."
fi

cd $1
dir=$PWD

if [ ! -f $dir/.workspace ]; then
    echo "Workspace file not found in directory"
    exit
fi

name=${PWD##*/}
cd $OLDPWD

cd $dir; zsh -c "ARGV0=zsh ZDOTDIR=$USR/.workspace WORKSPACE=$dir WORKSPACE_NAME=$name exec zsh"