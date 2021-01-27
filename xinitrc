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

#
# Load helpers functions
source ~/.xinitrc-helpers.sh

#
# Load X resources and theme
#
xrdb -load ~/.Xresources
xrdb -merge ~/.xresources-themes/solarized/xresources/solarized 

#
# swap commma for period on numeric pad
#
setxkbmap br -option kpdl:dot

#xsetroot -xcf /usr/share/icons/mac-aqua-cursor/cursors/left_ptr 32

#xautolock -time 12 -locker "systemctl suspend" -detectsleep &>/dev/null

# Manage transparency
xcompmgr &

# Switch off speaker.
xset -b

# load bindkey from ~/.xbindkeys
xbindkeys

#
# IBM PS2 keyboard has dead key (|\/?) with adapter
# map right windows key (134) for pipe (|)
#xmodmap -e "keycode 134 = bar"

#
# Check if there is an extern keyboard
# see xinitrc-functions.sh for array of keyboard models
#
if IsExternKeyboardConnected; then
   numlockx &
   ACTION='add' DELAY=y /usr/local/bin/setkb.sh br
else
   ACTION='add' DELAY=y /usr/local/bin/setkb.sh br
   syndaemon -i 0.5 -d & disown
   # syndaemon does not work if psmouse module is up
   sudo modprobe -r psmouse
fi

#
# WARNING:
#         WORKAROUND
# When this line is removed xrandr does not find the
# resolution 3840x2160. Why? i have no idea
#
xrandr &>/dev/null

#
# Set scale since 4K monitors are too small.
#
outputs=$(GetStatusOfDisplay)
if [ $? -gt 1 ]; then
   ${HOME}/.screenlayout/layout.sh
   #xrandr --output HDMI1 --mode 1920x1080 --scale 1.3x1.3 --right-of eDP1 --output eDP1 --mode 1920x1080
else
   xrandr --output eDP1 --primary --mode 1920x1080 --rate 60 --scale 1.1x1.1
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

###
# WARNING:
#   BUG xbacklight returns 'No outputs have backlight property'.
#
# Set monitor backlight.
# xbacklight -set 60%

###
# Set backlight to 80%
#
# WARNING:
#   DO NOT USE xbacklight, BUG (see above).
#xrandr --output eDP-1 --brightness 0.9

disable_debug() {
    set +x
    exec 4>&1
    exec 5>&2
    exec 4>&-
    exec 5>&-
}
disable_debug

# starts the window manager
#exec dbus-launch --sh-syntax --exit-with-session /usr/bin/i3 -c "/tmp/i3.conf"
exec /usr/bin/i3 -c "/tmp/i3.conf"

