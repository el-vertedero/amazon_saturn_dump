#!/system/bin/sh

if [[ -f /cache/recovery/last_user_data_needs_resize ]]
then
  echo "Resizing userdata partition." > /dev/kmsg
  /system/bin/e2fsck -y -f /dev/block/platform/msm_sdcc.1/by-name/userdata > /cache/resize_log 2>&1
  /system/bin/tune2fs -T now /dev/block/platform/msm_sdcc.1/by-name/userdata >> /cache/resize_log 2>&1
  /system/bin/resize2fs -f /dev/block/platform/msm_sdcc.1/by-name/userdata -16K >> /cache/resize_log 2>&1
  if [[ "$?" -eq 0 ]]
  then
    echo "Resizing userdata partition done." > /dev/kmsg
    /system/bin/rm /cache/recovery/last_user_data_needs_resize
  else
    echo "Resizing userdata partition failed. ret:$?" > /dev/kmsg
  fi
else
  echo "User data doesn't need resize." > /dev/kmsg
fi

