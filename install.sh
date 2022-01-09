#!/usr/bin/env bash

if [ "$(id -u)" = 0 ]; then
	echo "don't run this as root"
	exit
fi

error() { \
	    clear; printf "ERROR:\\n%s\\n" "$1" >&2; exit 1;
}

sudo pacman --noconfirm --needed -Syu dialog || error "Error Upgrading or Syncing pkgs and repos."

dialog --colors --title "\Z7\ZbStay near your computer!" --yes-label "Continue" --no-label "Exit" --yesno "\Z4This script is not allowed to be run as root, but you will be asked to enter your sudo password at various points during this installation. This is to give PACMAN the necessary permissions to install the software.  So stay near the computer." 8 60

sudo pacman --noconfirm --needed -Syu - < neededpkglist.txt

while true; do
	read -p "Do you want the extra packages in extrapkglist.txt? [Y/n]" yn
		case $yn in
			"" ) ;&
			[Yy]* ) sudo pacman --noconfirm --needed -Syu - < extrapkglist.txt;;
			[Nn]* ) break;;
			* ) echo "please answer yes or no.";;
		esac
done

mkdir -p $HOME/.config/

cp -v $HOME/Configs/* $HOME/.config

cd $HOME/.config

rm extrapkglist.txt; rm neededpkglist.txt; rm README.md
