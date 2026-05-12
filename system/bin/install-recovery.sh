#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/recovery:15790080:a8a39d696246f4ba9f60f0cd97731d49a619a8fe; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:15151104:8a87fd1721193c84d4dabd7628c74d24c860f451 EMMC:/dev/block/platform/msm_sdcc.1/by-name/recovery a8a39d696246f4ba9f60f0cd97731d49a619a8fe 15790080 8a87fd1721193c84d4dabd7628c74d24c860f451:/system/recovery-from-boot.p && echo "
Installing new recovery image: succeeded
" >> /cache/recovery/log || echo "
Installing new recovery image: failed
" >> /cache/recovery/log
else
  log -t recovery "Recovery image already installed"
fi
