#!/bin/bash

# Ensure the script is running with sudo privileges
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run this script as root or with sudo privileges."
  exit 1
fi

# Update system and install necessary packages
echo "Updating system and installing necessary packages (git, flatpak)..."
pacman -Syu --noconfirm git flatpak

# Setup home directory structure
echo "Setting up home directory..."
mkdir -p ~/Code ~/Desktop ~/Documents ~/Downloads ~/Media/{music,pictures,video}

# Clone the dwm repository
echo "Cloning dotfile repository..."
cd ~
git clone https://github.com/wllnut/dwm
cd dwm

# Install packages from pacman_packages.list if it exists
if [ -f pacman_packages.list ]; then
  echo "Installing packages from pacman_packages.list..."
  pacman -S --noconfirm - < pacman_packages.list
else
  echo "pacman_packages.list not found, skipping pacman package installation."
fi

# Install yay from the AUR if yay is not already installed
cd ~
echo "Installing yay from the AUR..."
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~
rm -rf yay

# Install Flatpak packages from flatpak_packages.list if it exists
if [ -f flatpak_packages.list ]; then
  echo "Installing Flatpak packages from flatpak_packages.list..."
  flatpak install -y < flatpak_packages.list
else
  echo "flatpak_packages.list not found, skipping Flatpak package installation."
fi

# Function to copy files if they exist
copy_file_if_exists() {
  if [ -f "$1" ]; then
    cp "$1" "$2"
  else
    echo "$1 not found, skipping."
  fi
}

# Copy configuration files
echo "Copying configuration files..."
for file in .xinitrc .zshrc .zsh_history; do
  [ ! -f ~/$file ] && cp dwm/$file ~/$file
done

copy_file_if_exists "dwm/.oh-my-zsh" "~/.oh-my-zsh"
copy_file_if_exists "dwm/.config" "~/.config"

# Copy wallpaper if it exists
copy_file_if_exists "dwm/wallpaper" "~/Media/pictures/.wallpaper"

# Copy code files
echo "Copying code files..."
cp -r dwm/Code ~/Code

# Install suckless programs
echo "Installing Suckless programs..."
cd ~/.config/Suckless/dwm && sudo make clean install
cd ~/.config/Suckless/dmenu && sudo make clean install
cd ~/.config/Suckless/slock && sudo make clean install
cd ~/.config/Suckless/slstatus && sudo make clean install

# Set the wallpaper if the file exists
if [ -f ~/Media/pictures/.wallpaper/wallpaper.png ]; then
  echo "Setting wallpaper..."
  feh --bg-scale ~/Media/pictures/.wallpaper/wallpaper.png
else
  echo "Wallpaper not found, skipping wallpaper setting."
fi

echo "Installation complete. You may want to manually start X using 'startx' or reboot your system."
