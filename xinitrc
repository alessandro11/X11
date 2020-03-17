#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

LOG_FILE=""

enable_debug() {
    LOG_FILE=$(mktemp --suffix="-i3-${USER}-$(date +%FT%T).log")
    exec 4>> "$LOG_FILE"
    exec 5>> "$LOG_FILE"
    exec 1>&4
    exec 2>&5
    set -x
}
enable_debug

source ~/.xinitrc-functions.sh

# Laod x resources
xrdb -load ~/.Xresources
xrdb -merge ~/solarized/xresources/solarized

# Manage transparency
xcompmgr &

# Sets the default cursor.
#xsetroot -cursor_name left_ptr

# Switch off speaker.
xset -b

### DEPRECATED
# Now is at /etc/X11/xorg.conf.d/00-keyboard.conf.
#setxkbmap -option terminate:ctrl_alt_bksp & # Set short-cutkey for end session

# Set monitor backlight.
xbacklight -set 60%

# load bindkey from ~/.xbindkeys
xbindkeys

#
# IBM PS2 keyboard has dead key (|\/?) with adapter
# map right windows key (134) for pipe (|)
xmodmap -e "keycode 134 = bar"

#
# Check if there is an extern keyboard
#
if ! IsExternKeyboardConnected; then
   #ACTION='add' DELAY=y /usr/local/bin/setkb.sh
   syndaemon -i 0.5 -K -R -d
   # syndaemon does not work if psmouse module is up
   sudo modprobe -r psmouse
fi

xrandr --listmonitors
sleep 3
#
# Set scale since 4K monitors are too small.
#
outputs=$(GetStatusOfDisplay)
if [ $? -gt 1 ]; then
   xrandr --output eDP1 --mode 3200x1800 --scale 0.4x0.4 --left-of DP1 \
          --output DP1 --primary --mode 1920x1080
else
   xrandr --output eDP1 --primary --mode 3200x1800 --scale 0.35x0.35
fi

#
# Parse config it will generate /tmp/i3.conf
#
pushd "$HOME/.config/i3"
$HOME/.config/i3/parse-config.sh -o $outputs
popd

#
# Set wallpaper; set after redimentioning the display.
#
feh --bg-fill ~/.wallpaper/archlinux-leder-arCh-asKaliLogo.jpg

###
# Load DISPLAY and XAUTHORITY in systemd env
/etc/X11/xinit/xinitrc.d/50-systemd-user.sh

disable_debug() {
    set +x
    exec 4>&1
    exec 5>&2
    exec 4>&-
    exec 5>&-
}
disable_debug

# starts the window manager
exec /usr/bin/i3 -c "/tmp/i3.conf"
