#! /bin/bash 
# Script Description
# 1. Adds crontab for which checks for script updates
# 2. Adds soundLevelMeter Script to startup

SOUND_LEVEL_HOME=/home/pi/soundLevelMeter
WHO_AM_I=$(whoami)

echo "INFO: Start install script"
sleep 1


if [[ "$WHO_AM_I" != "root"]]; then
	echo "You must be root to install soundLevelMeter"
	exit 1
fi

echo "INFO: Add cronjob which checks for updates"

CRON_ENTRY="* * * * * ${SOUND_LEVEL_HOME}/administration/checkForUpdates.sh >> ${SOUND_LEVEL_HOME}/logs/checkForUpdates.log 2>&1"
TEMP_FILE=/tmp/temp_crontab_entries.txt

crontab -l -u root | grep -v "checkForUpdates.sh" > $TEMP_FILE
echo $CRON_ENTRY >> $TEMP_FILE
crontab -u root $TEMP_FILE


echo -n "INFO: add soundLevelMeter script to startup routine"
cp "${SOUND_LEVEL_HOME}/administration/soundLevelMeterStart.sh" /etc/init.d
update-rc.d /etc/init.d/soundLevelMeterStart.sh defaults 

echo -n "INFO: Finished install script"