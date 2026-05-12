#!/system/bin/sh

FACTORY_TOOL="/system/bin/factory_provision_tool"
REPROVISION_REBLOW_LOG_FILE="/persist/reprovisioning_log"
REPROVISION_REBLOW_TMP_FILE="/persist/reprovisioning_tmp"
REPROVISION_CHECK="/persist/reprovisioning_ok"
PROVISION_CHECK="/persist/provisioning_ok"
REBLOW_CHECK="/persist/reblow_config_ok"
LICENSE_CHECK="/persist/data/app_ms/keyfile.dat"

function log_message {
	echo "$*"
	echo "$*" >> $REPROVISION_REBLOW_LOG_FILE
}

function update_log {
	cat $REPROVISION_REBLOW_TMP_FILE
	cat $REPROVISION_REBLOW_TMP_FILE >> $REPROVISION_REBLOW_LOG_FILE
	rm $REPROVISION_REBLOW_TMP_FILE
}

function call_command {
	log_message "$*"
	$* >> $REPROVISION_REBLOW_TMP_FILE
}

function check_exit_status {
	if [ $? != 0 ]; then
		update_log
		log_message "**************"
		log_message "ERROR OCCURRED"
		log_message "**************"
		exit 1
	else
		update_log
	fi
}

sleep 5

# Set up correct umask
umask 000

# Clean up provisioning log file
rm -f $REPROVISION_REBLOW_LOG_FILE

# Check device type
BOARD_ID=`idme print | grep "board_id"`
BOARD_ID=${BOARD_ID:10}

if [ ${BOARD_ID:10:1} == '0' ]; then
        log_message "==========================================="
	log_message "WARNING: THIS DEVICE IS MEANT TO HAVE JTAG"
	log_message "NOT REBLOWING CONFIG FUSE OR REPROVISIONING"
	log_message "==========================================="

else
	log_message "-------------------------------"
	log_message "START REBLOWN CONFIG FUSE CHECK"
	log_message "-------------------------------"

	if [ ${BOARD_ID:8:1} -ge '4' ] && [ ${BOARD_ID:8:1} -le '8' ]
	then
		if [ -f "$REBLOW_CHECK" ]
		then
			log_message "================================================"
			log_message "WARNING: DEVICE DOES NOT NEED REBLOW CONFIG FUSE"
			log_message "================================================"

		else
			log_message "=============================="
			log_message "DEVICE NEED REBLOW CONFIG FUSE"
			log_message "START REBLOWING"
			log_message "=============================="
			CMD="$FACTORY_TOOL fuse -cf"
			call_command $CMD
			check_exit_status
			touch /persist/reblow_config_ok
		fi

	else
		log_message "======================================="
		log_message "WARNING: NOT EVT2 OR DVT DEIVES"
		log_message "DEVICE DOES NOT NEED REBLOW CONFIG FUSE"
		log_message "======================================="
	fi

	log_message "--------------------------"
	log_message "START REPROVISIONING CHECK"
	log_message "--------------------------"

        if [ -f "$LICENSE_CHECK" ]
        then
            log_message "LICENSE check ok"
        else
            rm -rf /persist/data/
            rm $REPROVISION_CHECK
            rm $PROVISION_CHECK
            log_message "Force to reprov"
        fi

        if [ -f "$REPROVISION_CHECK" ] || [ -f "$PROVISION_CHECK" ]
        then
                log_message "========================================="
                log_message "WARNING: DEVICE DOES NOT NEED REPROVISION"
                log_message "========================================="

	else
                log_message "======================="
                log_message "DEVICE NEED REPROVISION"
                log_message "START REPROVISIONING"
                log_message "======================="
                CMD="$FACTORY_TOOL ipc_prov"
                call_command $CMD
                check_exit_status
                touch /persist/reprovisioning_ok
                sync
        fi
fi

log_message "********"
log_message "FINISHED"
log_message "********"
exit 0
