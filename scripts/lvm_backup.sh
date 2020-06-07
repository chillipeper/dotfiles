#!/bin/bash - 
#===============================================================================
#
#          FILE: lvm_backup.sh
# 
#         USAGE: ./lvm_backup.sh 
# 
#   DESCRIPTION: Take backups of logical volumes into an external drive 
#		 For the script to work, following environment variables have to be present:
#
#		 BACKUP_MOUNTPOINT --> Absolute path where backup should be placed
#		 VG --> Volume Group where we want to take the backup from 
#		 LVs --> Space Separated Logical Volume(s) that have to be backed up. ie: LVs="lv1 lv2"
#
#        AUTHOR: chillipeper
#  ORGANIZATION: 
#       CREATED: 05.06.2020 12:01
#===============================================================================

set -o nounset                              # Treat unset variables as an error

CONFIG_FILE=~/.lvm_backup_vars
SNAPSHOT_MOUNTPOINT=/mnt

load_env_vars ()
{
	
	if [ -a $CONFIG_FILE ] ; then
		source $CONFIG_FILE
	else
		read -p "BACKUP_MOUNTPOINT: " BACKUP_MOUNTPOINT
		read -p "VG to backup: " VG
		read -p "Logical volumes to backup (space separated): " LVs
	fi

	# Validations
	[ -z "$BACKUP_MOUNTPOINT" ] && echo "BACKUP_MOUNTPOINT variable not set!!" && exit 1
	[ -z "$VG" ] && echo "VG variable not set!!" && exit 1
	[ -z "$LVs" ] && echo "LVs variable not set!!" && exit 1
	[ ! -d "$BACKUP_MOUNTPOINT" ] && echo "$BACKUP_MOUNTPOINT not available!!!" && exit 1



	if [ -z "$CONFIG_FILE" ]; then
		echo BACKUP_MOUNTPOINT=$BACKUP_MOUNTPOINT > $CONFIG_FILE
		echo VG=$VG >> $CONFIG_FILE
		echo LVs=\"$LVs\" >> $CONFIG_FILE
	fi

}	# ----------  end of function load_env_vars  ----------

load_env_vars



for lv in $LVs ; do
	LV_PATH=/dev/$VG/$lv
	SNAPSHOT_LV_PATH=/dev/$VG/$lv-snapshot

	# Verify if snapshot lv exists and if it is mounted
	if $(sudo lvs $SNAPSHOT_LV_PATH > /dev/null 2>&1) ; then
		mountpoint=$(findmnt -n /dev/linux-vg/ubuntu-root-lv-snapshot | awk '{print $1}' 2> /dev/null)
		if [ "$mountpoint" ]; then
			echo -e "$SNAPSHOT_LV_PATH is currently mounted on $mountpoint"
			echo -e "Umounting $mountpoint"
			sudo umount $mountpoint || exit 1
		fi
		echo -e "$SNAPSHOT_LV_PATH is already created, removing before backup"
		sudo lvremove -y $SNAPSHOT_LV_PATH || exit 1
	fi

	echo -e "Starting backup:"
	sudo lvcreate -L5G -s -n $lv-snapshot $LV_PATH
	sudo mount $SNAPSHOT_LV_PATH $SNAPSHOT_MOUNTPOINT
	sudo dd if=$SNAPSHOT_LV_PATH of=$BACKUP_MOUNTPOINT/$lv.$(date +%F-%H:%M).dd status=progress
	sudo umount $SNAPSHOT_MOUNTPOINT
	sudo lvremove -y $SNAPSHOT_LV_PATH
done
