#!/bin/bash
# Install the custom asus_rt-n66u profile into an extracted OpenWrt ImageBuilder.
# Usage: install-profile.sh <imagebuilder-dir>
# The RT-N66U was dropped from official OpenWrt profiles (no release ships an
# image for it; the b43 driver is likewise gone from new releases -- 22.03.7 is
# the newest release with kmod-b43 in the package pool). This restores a
# minimal ASUS-profile so the ImageBuilder can produce a proper .trx.
set -euo pipefail
IB="${1:?usage: install-profile.sh <imagebuilder-dir>}"
[ -d "$IB/target/linux/bcm47xx/image" ] || { echo "bad IB dir: $IB" >&2; exit 1; }

# 1. Full replacement of generic.mk (adds Device/asus_rt-n66u).
#    Replacing the whole file (instead of patching) avoids diff-format drift
#    between ImageBuilder releases.
cp "$(dirname "$0")/../image/generic.mk" "$IB/target/linux/bcm47xx/image/generic.mk"

# 2. Register the profile in the shipped profile index (.profiles.mk).
#    The ImageBuilder does not regenerate .targetinfo/.profiles.mk from the
#    device Makefiles, so the new device must be added to the index by hand.
sed -i 's/DEVICE_linksys_e3000-v1 DEVICE_standard/DEVICE_linksys_e3000-v1 DEVICE_asus_rt-n66u DEVICE_standard/' "$IB/.profiles.mk"
cat >> "$IB/.profiles.mk" <<'EOF'
DEVICE_asus_rt-n66u_NAME:=ASUS RT-N66U
DEVICE_asus_rt-n66u_HAS_IMAGE_METADATA:=0
DEVICE_asus_rt-n66u_SUPPORTED_DEVICES:=asus,rt-n66u
DEVICE_asus_rt-n66u_PACKAGES:=kmod-bgmac kmod-b43
EOF

# 3. Per-device kernel image = the target's prebuilt kernel.
#    bcm47xx has no DTB; every device's -kernel.bin is a copy of vmlinux.lzma
#    (the ImageBuilder only ships -kernel.bin for its packaged devices).
KDIR="$IB/build_dir/target-mipsel_mips32_musl/linux-bcm47xx_generic"
cp "$KDIR/vmlinux.lzma" "$KDIR/asus_rt-n66u-kernel.bin"

echo "profile asus_rt-n66u installed"
