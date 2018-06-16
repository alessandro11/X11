#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

source ~/.xinitrc.incsh

xrdb -load ~/.Xresources      	        		# laod x resources
xcompmgr &  									# manage transparency
#xloadimage -fork -fullscreen -onroot ~/.arch-linux_00444952.jpg   # set background image
feh --bg-fill ~/.arch-wallpaper2.png
xsetroot -cursor_name left_ptr  			    # sets the cursor icon
xset -b	&									    # switch off speaker

# Now is at /etc/X11/xorg.conf.d/00-keyboard.conf
#setxkbmap -option terminate:ctrl_alt_bksp & # Set short-cutkey for end session

# Set monitor backlight
xbacklight -set 80%

# load bindkey from ~/.xbindkeys
#xbindkeys

# Is thre the warrior mechanical keyboard?
if lsusb -d "0c45:760a" >/dev/null 2>&1; then
	ACTION='add' DELAY=y /usr/local/bin/setkb.sh	# set the keyboard
fi


CONF="$HOME/.config/i3/config-LVDS1"
if IsHDMIConnected; then
    CONF="$CONF-HDMI1"
fi
if IsBatteryPlugged; then
    CONF="$CONF-BAT"
fi

# starts the window manager
exec /usr/bin/i3 -c "$CONF"
