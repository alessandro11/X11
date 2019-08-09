#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

VIDEO_OUT2="DP1"
VIDEO_OUT2_ENABLED=-1

source ~/.xinitrc-functions.sh

# Laod x resources
xrdb -load ~/.Xresources

# Manage transparency
#xcompmgr &

#xloadimage -fork -fullscreen -onroot ~/.arch-linux_00444952.jpg
feh --bg-fill ~/.wallpaper/system-failure.png

# Sets the default cursor.
#xsetroot -cursor_name left_ptr

# Switch off speaker.
xset -b

### DEPRECATED
# Now is at /etc/X11/xorg.conf.d/00-keyboard.conf.
#setxkbmap -option terminate:ctrl_alt_bksp & # Set short-cutkey for end session

# Set monitor backlight.
xbacklight -set 80%

# load bindkey from ~/.xbindkeys
xbindkeys 

### Check if the keyboard warrior (mechanical)
# is connected.
if ! lsusb -d "0c45:760a" >/dev/null 2>&1; then
   #ACTION='add' DELAY=y /usr/local/bin/setkb.sh
   syndaemon -i 0.5 -t -K -R -d
   # syndaemon does not work if psmouse module is up
   modprobe -r psmouse
fi

CONF="$HOME/.config/i3/config-eDP1"
if IsDP_1Connected; then
    CONF="$CONF-DP1"
    VIDEO_OUT2_ENABLED=0
else
    VIDEO_OUT2_ENABLED=1
fi

if IsBatteryPlugged -a IsBatteryDischarging; then
    CONF="$CONF-BAT"
fi

###
# Create set of monitors, it presents as an
# single monitor.
# xrandr --setmonitor mysetmonitors auto eDP1,DP1
[ $VIDEO_OUT2_ENABLED -eq 0 ] && \
    xrandr --output DP1 --primary

### Set scale since 4K monitors are too small.
xrandr --output eDP1 --scale 0.8x0.8

###
# Load DISPLAY and XAUTHORITY in systemd env
/etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# starts the window manager
exec /usr/bin/i3 -c "$CONF"
