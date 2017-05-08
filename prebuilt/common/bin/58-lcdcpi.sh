#!/sbin/sh
# /system/addon.d/58-lcdcpi.sh
# During an upgrade, this script backs up lcd.prop
# Taken from SlimRoms
# Tuxafgmur - Dhollmen

backuppath="/tmp/backup/prop"
mkdir -p $backuppath

backup_prop() {
    cp "/system/build.prop" "$backuppath/build.prop"
}

restore_prop() {
    if [ -f "$backuppath/build.prop" ]; then
	local USERLCD=`sed -n -e'/ro\.sf\.lcd_density/s/^.*=//p' $backuppath/build.prop`
	busybox sed -i "s|ro.sf.lcd_density=.*|ro.sf.lcd_density=$USERLCD|" /system/build.prop
    fi
}

case "$1" in
    backup)
        backup_prop
        ;;
    restore)
        restore_prop
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
