#!/bin/sh

cd ~
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git

# Setup home directory
mkdir Code
mkdir Desktop
mkdir Documents
mkdir Downloads
mkdir Media

mkdir .config

cd Media
mkdir music
mkdir pictures
mkdir video
mkdir .hidden

cd ~

# Clone github repo
git clone https://github.com/wllnut/dwm
cd dwm

# Install packages from pacman_packages.list
sudo pacman -S --noconfirm - < pacman_packages.list

# Install yay from aur
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

# Remove yay directory
cd ~
rm -rf yay

# Install flatpaks
cd dwm
cat flatpak_packages.list | xargs flatpak install -y
cd ~

# Copy config files
cd dwm
cp -r .config ~/.config
cp -r .oh-my-zsh ~/.oh-my-zsh
cp -r wallpaper ~/Media/pictures/.wallpaper
cp .xinitrc ~/.xinitrc
cp .zsh_history ~/.zsh_history
cp .zshrc ~/.zshrc

# Copy code files
cp -r Code ~/Code

# Install suckless programs
cd ~/.config/Suckless/dwm/ && sudo make clean install
cd ~/.config/Suckless/dmenu && sudo make clean install
cd ~/.config/Suckless/slock && sudo make clean install
cd ~/.config/Suckless/slstatus && sudo make clean install

# Start XORG session
startx

# Set wallpaper
feh --bg-scale ~/Media/pictures/.wallpaper/wallpaper.png

# Reboot
reboot
