# SD2 Boot Experiment Result

Timestamp: `20260721-183542`

## Outcome

`PASS`

The patched DTB caused the 512 GB SanDisk card in the second slot to initialize successfully as `/dev/mmcblk0`.

## Original and patched hashes

- Original DTB: `b1598a044a9e84b40d09cf347bd774c58661b9780b698d614c4c8c6a740e7682`
- Patched DTB: `53263514e6ea0bd9d02423ae2faa05ee98cf198d98ea2fc6441d0aea23b63287`

Console verification:

- Backup copy hash: `b1598a044a9e84b40d09cf347bd774c58661b9780b698d614c4c8c6a740e7682`
- Installed `/flash/dtbs/rk3326-gameconsole-r36s.dtb` hash: `53263514e6ea0bd9d02423ae2faa05ee98cf198d98ea2fc6441d0aea23b63287`

## Exact semantic diff

Only `mmc@ff380000` changed.

Changed:

- `max-frequency = <0x8f0d180>;` -> `max-frequency = <50000000>;`
- removed:
  - `sd-uhs-sdr12;`
  - `sd-uhs-sdr25;`
  - `sd-uhs-sdr50;`
  - `sd-uhs-sdr104;`

Unchanged:

- `mmc@ff370000`
- `bus-width`
- `cd-gpios`
- `disable-wp`
- `vmmc-supply`
- `vqmmc-supply`
- `pinctrl-*`
- `cap-sd-highspeed`

## Installation steps performed

1. Created a local test DTS copy at `research/sd2/build/rk3326-gameconsole-r36s-sd2-test.dts`.
2. Applied the SD2-only patch to that copy.
3. Compiled `research/sd2/build/rk3326-gameconsole-r36s-sd2-test.dtb`.
4. Decompiled the result and confirmed the only intended semantic changes were in `mmc@ff380000`.
5. Verified the console boot target inventory included `/flash/dtbs/rk3326-gameconsole-r36s.dtb`.
6. Created a timestamped backup on the console under `/storage/sd2-test-backup-20260721-183542/`.
7. Remounted `/flash` read-write for the minimum window required.
8. Replaced only `/flash/dtbs/rk3326-gameconsole-r36s.dtb`.
9. Verified the copied DTB hash on the console.
10. Remounted `/flash` read-only.
11. Rebooted once.

## Post-boot MMC evidence

`/proc/partitions`:

- `mmcblk1` present for the system card
- `mmcblk0` present for the second slot
- `mmcblk0` size: `499871744` blocks

`/dev/mmcblk*`:

- `/dev/mmcblk0`
- `/dev/mmcblk0p1`
- `/dev/mmcblk1`
- `/dev/mmcblk1p1`
- `/dev/mmcblk1p2`
- `/dev/mmcblk1p3`

Post-boot `dmesg` highlights:

- `mmc0` now initializes at `50000000Hz`
- `mmc0: new high speed SDXC card at address aaaa`
- `mmcblk0: mmc0:aaaa SK512 477 GiB`
- no `error -110` after the patch

## Final DTB state on the console

The console is still using the patched DTB:

- `/flash/dtbs/rk3326-gameconsole-r36s.dtb`
- hash: `53263514e6ea0bd9d02423ae2faa05ee98cf198d98ea2fc6441d0aea23b63287`

## Raw logs

Stored under:

- `research/sd2/results/20260721-183542/`

Files:

- `proc-partitions.txt`
- `dev-mmcblk.txt`
- `mmc-dmesg-postboot.txt`