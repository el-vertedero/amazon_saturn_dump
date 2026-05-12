#!/system/bin/sh

if [ -e /data/AUTO_SHUTDOWN ]; then
	sqlite3 /data/data/com.android.providers.settings/databases/settings.db "update system set value='1800000' where name='screen_off_timeout';"
	sleep 60
	reboot -p
fi
