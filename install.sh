#!/usr/bin/env bash

##checks to make sure user is not root
if [ "$(id -u)" = 0 ]; then
	echo "don't run this as root"
	exit
fi

cd $HOME

error() { \
	    clear; printf "ERROR:\\n%s\\n" "$1" >&2; exit 1;
}

##adds some basic deps

sudo pacman --noconfirm --needed -Syu dialog base-devel || error "Error Upgrading or Syncing pkgs and repos."

git clone https://aur.archlinux.org/yay-git.git

sudo chown -R roman:roman ./yay-git

cd yay-git

makepkg -si

cd $HOME/Configs

##installing all necessary pkgs

dialog --colors --title "\Z7\ZbStay near your computer!" --yes-label "Continue" --no-label "Exit" --yesno "\Z4This script is not allowed to be run as root, but you will be asked to enter your sudo password at various points during this installation. This is to give PACMAN the necessary permissions to install the software.  So stay near the computer." 8 60

yay --noconfirm --needed -Syu - < yay-pkg.txt 

yay --confirm --needed -Syu - < yay-conf-pkg.txt

sudo pacman --noconfirm --needed -Syu - < pacman-pkg.txt

sudo mkdir -pv $HOME/.config/

sudo mkdir -pv $HOME/Pictures/Wallpapers/Synthwave

cp -rv $HOME/Configs/* $HOME/.config

mv $HOME/.config/Snythwave $HOME/Pictures/Wallpapers

##curling xppentablet driver and picom sample conf for installed fork

sudo mkdir -p $HOME/Downloads

cd $HOME/Downloads

touch  picom.conf xppendriver.tar.xz

curl https://raw.githubusercontent.com/ibhagwan/picom/next-rebase/picom.sample.conf -o picom.conf

curl https://www.xp-pen.com/download/file/id/1936/pid/46/ext/gz.html -o xppendriver.tar.xz

mv picom.conf $HOME/.config/picom

tar -xf xppendriver.tar.xz

cd xp-pen-pentablet-*

sudo ./install.sh

##configuring lutris

sudo pacman -Syu --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls \
	mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
	lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
	sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
	ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 \
	lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader

##wget osu

cd $HOME/Downloads

wget https://github.com/ppy/osu/releases/download/2022.128.0/osu.AppImage

sudo chmod u+x osu.AppImage

##removing unnecessary files and directories
cd $HOME/.config

rm -rf $HOME/Configs/

rm -rf pacman-pkg.txt yay-conf-pkg.txt yay-pkg.txt install.sh README.md
