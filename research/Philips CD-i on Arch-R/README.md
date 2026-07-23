# Philips CD-i on Arch-R

## Purpose

This directory contains a verified Philips CD-i BIOS set required to run the
SAME CD-i RetroArch core on Arch-R.

The commonly distributed BIOS archive containing only:

- cdi200.rom
- cdi220b.rom

is incomplete and does not work with modern versions of SAME CD-i.

## Verified environment

- Arch-R (July 2026)
- RetroArch 1.22.2
- same_cdi_libretro

## ROM location

```
/storage/roms/cdi
```

Supported formats:

- CHD
- ISO
- CUE

## BIOS installation

Copy:

```
bios/cdimono1.zip
```

to:

```
/storage/roms/bios/same_cdi/bios/cdimono1.zip
```

## BIOS contents

This BIOS archive contains:

- cdi200.rom
- cdi220b.rom
- zx405037p__cdi_servo_2.1__b43t__llek9215.mc68hc705c8a_withtestrom.7201
- zx405042p__cdi_slave_2.0__b43t__zzmk9213.mc68hc705c8a_withtestrom.7206

## Common failure

If the two MCU firmware files are missing,
RetroArch reports:

```
Fatal error: Required files are missing, the machine cannot be run.
```

The log will also contain messages similar to:

```
zx405037... NOT FOUND
zx405042... NOT FOUND
```

## Diagnostic

```bash
retroarch -v \
  -L /usr/lib/libretro/same_cdi_libretro.so \
  "GAME.chd"
```