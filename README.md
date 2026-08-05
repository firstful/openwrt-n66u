# OpenWrt RT-N66U sniffer image (custom build)

Custom **OpenWrt 22.03.7** image for the ASUS RT-N66U, built for the wifi-positioning
project (Rook spec `architecture/wifi-positioning-spec.md`): the router runs a
**monitor-mode radio** that overhears all 2.4 GHz clients (both UniFi APs'
channels) and reports per-MAC RSSI for triangulation.

**Why 22.03.7:** it is the **newest OpenWrt release that still ships `kmod-b43`**
in its package pool (the b43 driver was removed from OpenWrt source after that;
no release 23.05/24.10/25.12 has it, and the RT-N66U device profile was dropped
even earlier). Verified against the official indices 2026-08-05. Alternative: a
full source build with b43 re-enabled, but that loses no capability for this
appliance (kernel 5.10, LAN-only sniffer).

## What's baked in

- `PROFILE=asus_rt-n66u` restored (generic.mk `Device/asus_rt-n66u` — ASUS trx
  header, PRODUCTID RT-N66U, VERSION 3.0.0.4) so TFTP flashing works
- Packages: `kmod-b43 kmod-bgmac tcpdump mosquitto-client-ssl curl ca-certificates`
- **b43 firmware blobs** at `/lib/firmware/b43/` (117 files, extracted from the
  Broadcom wl 5.100.138 driver via b43-fwcutter — the canonical set; mainline
  linux-firmware no longer ships them)
- First-boot config (`/etc/uci-defaults/99-sniffer`):
  - LAN **static 192.168.1.254/24** (OPNsense owns .1), gw/dns 192.168.1.1
  - radio0 (2.4 GHz) = **monitor mode**, ch6, HT20, US regdom; no AP
  - hostname `n66u-sniffer`

## Build

Gitea Actions (`.gitea/workflows/build.yaml`) runs the ImageBuilder + the
profile install script and uploads `dist/` as artifact `openwrt-n66u-22.03.7`.

Manual reproduce:

```
V=22.03.7; TGT=bcm47xx/generic
wget https://downloads.openwrt.org/releases/$V/targets/$TGT/openwrt-imagebuilder-$V-$TGT.Linux-x86_64.tar.xz
tar xf openwrt-imagebuilder-$V-$TGT.Linux-x86_64.tar.xz
bash scripts/install-profile.sh openwrt-imagebuilder-$V-$TGT.Linux-x86_64
make -C openwrt-imagebuilder-$V-$TGT.Linux-x86_64 image \
  PROFILE=asus_rt-n66u \
  PACKAGES="kmod-b43 kmod-bgmac tcpdump mosquitto-client-ssl curl ca-certificates" \
  FILES=files
```

## Flash (RT-N66U is currently bricked — ASUS TFTP rescue)

The device is in TFTP recovery mode (power off → hold RESET → power on → release
when power LED blinks slow). Operator machine wired **directly into a router LAN
port**:

```
tftp 192.168.1.1
binary
put openwrt-22.03.7-bcm47xx-generic-asus_rt-n66u-squashfs.trx
# ~2-3 min reflash + reboot
```

## First boot

```
ssh root@192.168.1.254     # set a password: passwd
iw dev                     # expect phy0 (2.4G). phy1 (5G) = b43 TBD
iw dev mon0 info           # monitor iface on ch6
```

5 GHz caveat: b43's BCM4331 5 GHz support is unverified (design tolerates
2.4 GHz-only sniffing — see the positioning spec §5.2).
