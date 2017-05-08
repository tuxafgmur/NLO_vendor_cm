#!/sbin/sh
# Validate that the update is compatible with already-installed system

grep -q "Command:.*\"--wipe\_data\"" /tmp/recovery.log
[ $? -eq 0 ] && exit 0

grep -q "Command:.*\"--headless\"" /tmp/recovery.log
[ $? -eq 0 ] && exit 0

if [ -f "/data/system/packages.xml" -a -f "/tmp/releasekey" ]; then
    relkey=$(cat "/tmp/releasekey")
    OLDIFS="$IFS"
    IFS=""
    while read line; do
        [ "${#line}" -gt 4094 ] && continue
        params=${line# *<package *}
        if [ "$line" != "$params" ]; then
            kvp=${params%% *}
            params=${params#* }
            while [ "$kvp" != "$params" ]; do
                key=${kvp%%=*}
                val=${kvp#*=}
                vlen=$(( ${#val} - 2 ))
                val=${val:1:$vlen}
                [ "$key" = "name" ] && package="$val"
                kvp=${params%% *}
                params=${params#* }
            done
            continue
        fi
        params=${line# *<cert *}
        if [ "$line" != "$params" ]; then
            keyidx=""
            keyval=""
            kvp=${params%% *}
            params=${params#* }
            while [ "$kvp" != "$params" ]; do
                key=${kvp%%=*}
                val=${kvp#*=}
                vlen=$(( ${#val} - 2 ))
                val=${val:1:$vlen}
                [ "$key" = "index" ] && keyidx="$val"
                [ "$key" = "key" ] && keyval="$val"
                kvp=${params%% *}
                params=${params#* }
            done
            if [ -n "$keyidx" ]; then
                [ "$package" = "com.android.htmlviewer" ] && cert_idx="$keyidx"
            fi
            [ -n "$keyval" ] && eval "key_$keyidx=$keyval"
            continue
        fi
    done < "/data/system/packages.xml"
    IFS="$OLDIFS"

    [ -z "$cert_idx" ] && exit 0

    varname="key_$cert_idx"
    eval "pkgkey=\$$varname"
    if [ "$pkgkey" != "$relkey" ]; then
        echo "The installed system isn't signed with present build's key, aborting..."
        exit 124
    fi
fi
exit 0
