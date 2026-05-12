#!/system/bin/sh
trycount=0
while [ $trycount -lt 3 ];
do
    pingstat=`idc ping`
    if [ "$pingstat" = "0" ]; then
        break
    else
        sleep 5
    fi
    trycount=$(( trycount + 1 ))
done

if [ "$pingstat" != "0" ]; then
    echo "Service otamode failed to contact installd" >/dev/kmsg
    /system/bin/setprop ota.state "trigger_abort_otamode"
    exit 1
else
    echo -n "Service otamode started. Wipe status: " >/dev/kmsg
    /system/bin/idc wipedalvikcache -1 0 >/dev/kmsg
    /system/bin/setprop config.disable_noncore 1
    /system/bin/setprop ota.state "trigger_restart_min_framework"
fi
exit 0
