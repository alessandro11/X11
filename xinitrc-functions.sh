IsHDMIConnected() {
    [ "`cat /sys/class/drm/card0-HDMI-A-1/status`" == "connected" ] && \
        return 0;

    return 1;
}

IsDP_1Connected() {
    [ "`cat /sys/class/drm/card0-DP-1/status`" == "connected" ] && \
        return 0;

    return 1;
}

IsHDMI1360x768() {
    if grep --quiet --word-regexp '1360x768' /sys/class/drm/card0-HDMI-A-1/modes; then
        return 0;
    fi

    return 1;
}

IsDP1_1366x768() {
    if grep --quiet --word-regexp '1366x768' /sys/class/drm/card0-DP-1/modes; then
        return 0;
    fi

    return 1;
}

IsBatteryPlugged() {
    [ -d "/sys/class/power_supply/BAT0" ] && return 0

    return 1;
}

IsBatteryDischarging() {
    [ "` cat /sys/class/power_supply/BAT0/status`" == "Discharging" ] && return 0;

    return 1;
}