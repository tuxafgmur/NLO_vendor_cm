#!/sbin/sh
# /system/addon.d/50-rom.sh
# During an upgrade, this script backs up some files
# Tuxafgmur - Dhollmen

. /tmp/install/bin/backuptool.functions

list_files() {
cat <<EOF
etc/hosts
etc/sysctl.conf
media/bootanimation.zip
EOF
}

case "$1" in
    backup)
	list_files | while read FILE DUMMY; do
	    backup_file $S/$FILE
	done
	;;
    restore)
	list_files | while read FILE REPLACEMENT; do
	    R=""
	    [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
	    [ -f "$C/$S/$FILE" ]  && restore_file $S/$FILE $R
	done
	;;
    pre-backup)
	;;
    post-backup)
	;;
    pre-restore)
	;;
    post-restore)
	;;
esac
