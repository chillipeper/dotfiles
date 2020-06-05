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

CONFIG_FILE=".lvm_backup_vars"

load_env_vars ()
{
	
	if [ -a $CONFIG_FILE ] ; then
		source $CONFIG_FILE
	else
		read -p "BACKUP_MOUNTPOINT: " BACKUP_MOUNTPOINT
		read -p "VG to backup: " VG
		read -p "Logical volumes to backup (space separated): " LVs
		echo "BACKUP_MOUNTPOINT=$BACKUP_MOUNTPOINT" >> $CONFIG_FILE
		echo "VG=$VG" >> $CONFIG_FILE
		echo "LVs=$LVs" >> $CONFIG_FILE
	fi
}	# ----------  end of function load_env_vars  ----------

load_env_vars

[ -z "$BACKUP_MOUNTPOINT" ] && echo "BACKUP_MOUNTPOINT variable not set!!" && exit 1
[ -z "$VG" ] && echo "VG variable not set!!" && exit 1
[ -z "$LVs" ] && echo "LVs variable not set!!" && exit 1


for lv in $LVs ; do
	sudo lvcreate -L5G -s -n $lv-snapshot /dev/$VG/$lv
	sudo mount /dev/$VG/$lv-snapshot /mnt
	sudo dd if=/dev/$VG/$lv-snapshot of=$BACKUP_MOUNTPOINT/$lv.$(date +%F-%H:%M).dd status=progress
	sudo umount /mnt
	sudo lvremove -y /dev/$VG/$lv-snapshot
done
