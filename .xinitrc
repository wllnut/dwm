#!/bin/sh

# Set wallpaper using feh
feh --bg-scale ~/Media/pictures/.wallpaper/wallpaper.png &

# Start the status bar (using slstatus, modify if you're using another)
~/.config/Suckless/slstatus/slstatus &

# Start any background applications (add more as needed)
# For example, you can start a compositor, like picom, if you want window effects
picom &

# Launch dwm as the window manager
exec dwm
