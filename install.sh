#!/bin/bash

# Ensure the script is running with sudo privileges when needed
echo "Running script as user..."
# Updating the system and installing necessary packages (requires root privileges)
echo "Updating system and installing necessary packages (git, flatpak)..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git flatpak zsh

# Setup home directory structure
echo "Setting up home directory..."
mkdir -p ~/Code ~/Desktop ~/Documents ~/Downloads ~/Media/{music,pictures,video} ~/.config/Suckless

# Clone the dwm repository into the user's home directory
echo "Cloning dotfile repository..."
cd ~
git clone https://github.com/wllnut/dwm
cd dwm

# Install packages from pacman_packages.list if it exists
  echo "Installing packages from pacman_packages.list..."
  sudo pacman -S --noconfirm - < pacman_packages.list

# Install yay from the AUR if yay is not already installed
  echo "Installing yay from the AUR..."
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ~
  rm -rf yay

# Install Flatpak packages from flatpak_packages.list if it exists
  echo "Installing Flatpak packages from flatpak_packages.list..."
  flatpak install -y < flatpak_packages.list
  
# Function to copy files if they exist
copy_file_if_exists() {
  if [ -f "$1" ]; then
    cp "$1" "$2"
  else
    echo "$1 not found, skipping."
  fi
}

copy_dir_if_exists() {
  if [ -f "$1" ]; then
    cp -r "$1" "$2"
  else
    echo "$1 not found, skipping."
  fi
}

# Copy configuration files to the user's home directory
echo "Copying configuration files..."
for file in .xinitrc .zshrc .zsh_history; do
  [ ! -f ~/$file ] && cp dwm/$file ~/$file
done

copy_dir_if_exists "dwm/.oh-my-zsh" "~/.oh-my-zsh"
cp -rp ~/dwm/{dwm/,dmenu,slstatus,slock} ~/.config/Suckless

# Copy wallpaper if it exists
cp -r ~/dwm/wallpaper ~/Media/pictures/.wallpaper

# Copy code files
echo "Copying code files..."
cp -r dwm/Code ~/Code

# Install suckless programs that require root permissions to install
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

echo "Installing Oh-My-Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Setting Zsh as the default shell..."
chsh -s $(which zsh)

echo "Installation complete. You may want to manually start X using 'startx' or reboot your system."
