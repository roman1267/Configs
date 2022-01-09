#!/usr/bin/env bash

if [ "$(id -u)" = 0 ]; then
	echo "don't run this as root"
	exit
fi

cd $HOME

error() { \
	    clear; printf "ERROR:\\n%s\\n" "$1" >&2; exit 1;
}

sudo pacman --noconfirm --needed -Syu dialog base-devel || error "Error Upgrading or Syncing pkgs and repos."

git clone https://aur.archlinux.org/yay-git.git

sudo chown -R roman:roman ./yay-git

cd yay-git

makepkg -si

dialog --colors --title "\Z7\ZbStay near your computer!" --yes-label "Continue" --no-label "Exit" --yesno "\Z4This script is not allowed to be run as root, but you will be asked to enter your sudo password at various points during this installation. This is to give PACMAN the necessary permissions to install the software.  So stay near the computer." 8 60

yay --noconfirm --needed -Syu - < yay-pkg.txt 

sudo pacman --noconfirm --needed -Syu - < pacman-pkg.txt

mkdir -p $HOME/.config/

cp -rv $HOME/Configs/* $HOME/.config
