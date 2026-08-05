#################################################
# Subtarget generic
#################################################

  # BCM4705 with tg3
define Device/linksys_wrt300n-v1.1
  DEVICE_MODEL := WRT300N
  DEVICE_VARIANT := v1.1
  DEVICE_PACKAGES := kmod-tg3 kmod-b43
  $(Device/linksys)
  DEVICE_ID := EWC2
  VERSION := 1.51.2
endef
TARGET_DEVICES += linksys_wrt300n-v1.1

define Device/linksys_wrt310n-v1
  DEVICE_MODEL := WRT310N
  DEVICE_VARIANT := v1
  DEVICE_PACKAGES := kmod-tg3 kmod-b43
  $(Device/linksys)
  DEVICE_ID := 310N
  VERSION := 1.0.10
endef
TARGET_DEVICES += linksys_wrt310n-v1

define Device/linksys_wrt350n-v1
  DEVICE_MODEL := WRT350N
  DEVICE_VARIANT := v1
  DEVICE_PACKAGES := kmod-tg3 kmod-b43 $(USB2_PACKAGES)
  $(Device/linksys)
  DEVICE_ID := EWCG
  VERSION := 1.04.1
endef
TARGET_DEVICES += linksys_wrt350n-v1

define Device/linksys_wrt610n-v1
  DEVICE_MODEL := WRT610N
  DEVICE_VARIANT := v1
  DEVICE_PACKAGES := kmod-tg3 kmod-b43 $(USB2_PACKAGES)
  $(Device/linksys)
  DEVICE_ID := 610N
  VERSION := 1.0.1
endef
TARGET_DEVICES += linksys_wrt610n-v1

  # BCMA SoC with SSB WiFi
define Device/linksys_wrt610n-v2
  DEVICE_MODEL := WRT610N
  DEVICE_VARIANT := v2
  DEVICE_PACKAGES := kmod-bgmac kmod-b43 $(USB2_PACKAGES)
  $(Device/linksys)
  DEVICE_ID := 610N
  VERSION := 2.0.0
endef
TARGET_DEVICES += linksys_wrt610n-v2

define Device/linksys_e3000-v1
  DEVICE_MODEL := E3000
  DEVICE_VARIANT := v1
  DEVICE_PACKAGES := kmod-bgmac kmod-b43 $(USB2_PACKAGES)
  $(Device/linksys)
  DEVICE_ID := 61XN
  VERSION := 1.0.3
endef
TARGET_DEVICES += linksys_e3000-v1

# ASUS RT-N66U (BCM4706, dual BCM4331) -- custom profile restored for the
# wifi-positioning sniffer image (dropped from official OpenWrt profiles).
define Device/asus_rt-n66u
  $(Device/asus)
  DEVICE_MODEL := RT-N66U
  PRODUCTID := RT-N66U
  VERSION := 3.0.0.4
  DEVICE_PACKAGES := kmod-bgmac kmod-b43
endef
TARGET_DEVICES += asus_rt-n66u

# generic has Ethernet drivers as modules so overwrite standard image
define Device/standard
  DEVICE_VENDOR := Generic
  DEVICE_MODEL := Image with LZMA loader and LZMA compressed kernel
  DEVICE_PACKAGES := kmod-b44 kmod-bgmac kmod-tg3
endef
TARGET_DEVICES += standard
