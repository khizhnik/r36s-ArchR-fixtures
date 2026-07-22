# R36S Arch-R Fixtures

Research and tested fixes for Arch-R on the R36S handheld.

## Confirmed fix: SanDisk 512 GB card in TF2 slot

On Arch-R 20260709 / Linux 6.12.94, some SanDisk 512 GB cards fail to
initialize in the second SD slot with:

    mmc0: error -110 whilst initialising SD card

The tested fix changes only the second MMC controller:

- limits `mmc@ff380000` to 50 MHz;
- removes UHS SDR12/25/50/104 capabilities;
- leaves the system SD controller untouched.

After the patch:

    mmc0: new high speed SDXC card
    mmcblk0: mmc0:aaaa SK512 477 GiB

See:

- `research/sd2/sd2-test-result.md`
- `research/sd2/rk3326-gameconsole-r36s-sd2-minimal.patch`

## Tested environment

- R36S
- Arch-R 20260709
- Linux 6.12.94
- SanDisk 512 GB microSD
- second TF2 slot

## Warning

This repository contains experimental device-tree work.
Back up the original DTB before replacing anything.