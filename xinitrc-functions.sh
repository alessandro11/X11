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

IsDockConnected() {
    declare -r -A docks=(['DELL_DA300']='06c4:c412')

    for dock in ${!docks[@]}; do
        if lsusb -d ${docks[$dock]} >&/dev/null; then
            echo "$dock"
            return 0
        fi
    done

    return 1
}

GetStatusOfDisplay() {
    local displays="" aux=""
    local count=0

    pushd /sys/class/drm >/dev/null
    for d in $(ls -d */); do
        if [ -f "${d}/status" ] && [ "`<${d}/status`" == "connected" ]; then
            aux="${d#*-}"
            displays="${aux::-1},$displays"
            let "count++"
        fi
    done
    popd >/dev/null

    echo "`tr -d '-' <<< $displays`"
    return $count
}

IsExternKeyboardConnected() {
    declare -r -A keyboards=(['warrior']='0c45:760a' ['ibm']='13ba:0017')

    for keyboard in ${!keyboards[@]}; do
        if lsusb -d ${keyboards[$keyboard]} &>/dev/null; then
            echo "$keyboard"
            return 0
        fi
    done

    return 1
}
