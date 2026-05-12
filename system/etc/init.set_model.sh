#!/system/bin/sh

export PATH=/system/bin
if [ -e /proc/product_features/wan ]
then
    setprop ro.product.model KFSAWA
else
    setprop ro.product.model KFSAWI
fi
