#!/sbin/sh
# /system/addon.d/54-initd.sh
# During an upgrade, this script backs up init.d user scripts
# Tuxafgmur - Dhollmen

. /tmp/install/bin/backuptool.functions

add_file() {
cat <<EOF
$1
EOF
}

initd_files() {
    if [ -d $InitdDir ]; then
	cd $InitdDir
	for FILE in *; do
	    [ "$FILE" = "*" ] && continue
		case $FILE in
		    *-Config)
			;;
		    *-Clean)
			;;
		    *-Fstrim)
			;;
		    *)  add_file etc/init.d/$FILE
			;;
		esac
	done
    fi
}

case "$1" in
    backup)
	InitdDir=$S/etc/init.d
	initd_files | while read FILE DUMMY; do
	    backup_file $S/$FILE
	done
	;;
    restore)
	InitdDir=$C/$S/etc/init.d
	initd_files | while read FILE REPLACEMENT; do
	    R=""
	    [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
		if [ -f "$C/$S/$FILE" ]; then
		    restore_file $S/$FILE $R
			chown 0.2000 $S/$FILE
			chmod 0755 $S/$FILE
		fi
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
