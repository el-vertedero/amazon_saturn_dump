#!/system/bin/sh

# sepolicy update

sleep 5

# Set up correct umask
umask 000

chcon u:object_r:drm_data_file:s0 /data/data/app_ms
chcon u:object_r:drm_data_file:s0 /data/data/app_ms/license.hds

