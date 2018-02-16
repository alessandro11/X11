#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

xrdb -load ~/.Xresources      	        		# laod x resources
xcompmgr -c &									# manage transparency
#xloadimage -fork -fullscreen -onroot ~/.arch-linux_00444952.jpg &   # set background image
feh --bg-fill ~/.wallpaper/Arch_Linux_by_renanbirck.jpg &
xsetroot -cursor_name left_ptr &			   # sets the cursor icon
xset -b	&									   # switch off speaker

# Now is at /etc/X11/
#setxkbmap -option terminate:ctrl_alt_bksp & # Set short-cutkey for end session

# Set monitor backlight
xbacklight -set 80%

# load bindkey from ~/.xbindkeys
#xbindkeys

# Is thre the warrior mechanical keyboard?
if lsusb -d "0c45:760a"; then
	ACTION='add' DELAY=y /usr/local/bin/setkb.sh	# set the keyboard
fi

# check if is connected to battery, if yes load the apropriete conf
CONF="$HOME/.config/i3/config-nobattery"
if [ -d "/sys/class/power_supply/BAT0" ]; then
	CONF="$HOME/.config/config"
fi

# starts the window manager
exec /usr/bin/i3 -c "$CONF"
