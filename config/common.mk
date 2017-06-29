PRODUCT_BRAND ?= LineageOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    persist.sys.dun.override=0 \
    ro.build.selinux=1

# Default sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.alarm_alert=Tourmaline.ogg \
    ro.config.notification_sound=Omicron.ogg

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/bin/50-rom.sh:system/addon.d/50-rom.sh \
    vendor/cm/prebuilt/common/bin/54-initd.sh:system/addon.d/54-initd.sh \
    vendor/cm/prebuilt/common/bin/58-lcdcpi.sh:system/addon.d/50-lcdcpi.sh \
    vendor/cm/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/cm/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/cm/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.d/80-Clean:system/etc/init.d/80-Clean \
    vendor/cm/prebuilt/common/etc/init.d/85-Fstrim:system/etc/init.d/85-Fstrim \
    vendor/cm/prebuilt/common/bin/sysinit:system/bin/sysinit

# Dhollmen files
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/cm/prebuilt/common/xbin/busybox:system/xbin/busybox \
    vendor/cm/prebuilt/common/xbin/sysro:system/xbin/sysro \
    vendor/cm/prebuilt/common/xbin/sysrw:system/xbin/sysrw \
    vendor/cm/prebuilt/common/xbin/zipalign:system/xbin/zipalign

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# CM-specific files
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.local.rc:root/init.cm.rc \
    vendor/cm/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Theme engine
include vendor/cm/config/themes_common.mk

ifneq ($(TARGET_DISABLE_CMSDK), true)
include vendor/cm/config/cmsdk_common.mk
endif

# Required CM packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    CMAudioService \
    CMParts \
    Development \
    Profiles \
    WeatherManagerService

# Optional packages
PRODUCT_PACKAGES += \
    libemoji \
    LiveWallpapersPicker \
    PhotoTable \
    Terminal

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Custom packages
PRODUCT_PACKAGES += \
    AudioFX \
    CMSettingsProvider \
    Calculator \
    Eleven \
    Jelly \
    LineageSetupWizard \
    LiveLockScreenService \
    LockClock \
    Trebuchet \
    WallpaperPicker \
    Wallpapers \
    WeatherProvider

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Extra tools
PRODUCT_PACKAGES += \
    7z \
    bzip2 \
    curl \
    fsck.ntfs \
    gdbserver \
    lib7z \
    libsepol \
    micro_bench \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs \
    oprofiled \
    pigz \
    rsync \
    sqlite3 \
    strace \
    tune2fs \
    unrar \
    unzip \
    wget \
    zip

# Custom off-mode charger
ifneq ($(WITH_CM_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    cm_charger_res_images \
    font_log.png \
    libhealthd.cm
endif

# Exfat support
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# Mem and su (all build variants)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su

DEVICE_PACKAGE_OVERLAYS += vendor/cm/overlay/common

PRODUCT_VERSION_MAJOR = 14
PRODUCT_VERSION_MINOR = 1
PRODUCT_VERSION_MAINTENANCE := 0

CM_VERSION_MAINTENANCE := $(PRODUCT_VERSION_MAINTENANCE)

CM_POSTFIX := $(shell date +"%Y%m%d")
CM_BUILDTYPE := UNOFFICIAL
LINEAGE_VERSION := Dhollmen-$(PLATFORM_VERSION)-$(CM_BUILD).$(CM_POSTFIX)
CM_MOD_VERSION := $(PRODUCT_VERSION_MAJOR)-$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(CM_BUILD).$(CM_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.lineage.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.cm.version=$(LINEAGE_VERSION) \
    ro.cm.releasetype=$(CM_BUILDTYPE) \
    ro.modversion=$(LINEAGE_VERSION) \
    ro.cmlegal.url=https://lineageos.org/legal

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/cm/build/target/product/security/lineage

-include vendor/cm-priv/keys/keys.mk

CM_DISPLAY_VERSION := $(LINEAGE_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
    ifneq ($(CM_BUILDTYPE), UNOFFICIAL)
        ifndef TARGET_VENDOR_RELEASE_BUILD_ID
            ifneq ($(CM_EXTRAVERSION),)
                # Remove leading dash from CM_EXTRAVERSION
                CM_EXTRAVERSION := $(shell echo $(CM_EXTRAVERSION) | sed 's/-//')
                TARGET_VENDOR_RELEASE_BUILD_ID := $(CM_EXTRAVERSION)
            else
                TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
            endif
        else
            TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
        endif
        ifeq ($(CM_VERSION_MAINTENANCE),0)
            CM_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(CM_BUILD)
        else
            CM_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(CM_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(CM_BUILD)
        endif
    endif
endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.cm.display.version=$(CM_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/cm/config/partner_gms.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
