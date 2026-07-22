# dArkOS SD2 Patch Applicability

## 1. Exact dArkOS patch identified

- `patches/dts/0001-r36s-darkos-fix-sd2-compatibility.patch`
- It is the only DTS patch in the dArkOS series that changes SD-card host behavior.

## 2. Exact semantic change made by that patch

The patch lowers the SD host max clock from 150 MHz to 50 MHz and removes all UHS mode declarations:

- `max-frequency = <0x8f0d180>;` changed to `max-frequency = <50000000>;`
- removed:
  - `sd-uhs-sdr12;`
  - `sd-uhs-sdr25;`
  - `sd-uhs-sdr50;`
  - `sd-uhs-sdr104;`

The intended effect is to force a conservative SD mode for compatibility with cards or routing that fail at higher-speed/UHS negotiation. This is a board-level SD signaling correction, not a Linux 4.4 binding-specific trick.

From the live Arch-R mapping, the external second slot is:

- `mmc0 -> /sys/firmware/devicetree/base/mmc@ff380000`

So the patch is semantically about the external SD2 host node on this board.

## 3. Current Arch-R MMC configuration relevant to SD2

Evidence collected from the shipped Arch-R DTB and live boot logs:

- `/flash/dtbs/rk3326-gameconsole-r36s.dtb`
- `dmesg` mmc lines from the running system
- `cat /proc/cmdline`

Key live facts:

- `mmc0` is the failing external slot.
- `mmc1` is the working system card.
- The kernel command line does not name a DTB explicitly.

Relevant DTB semantics:

- `mmc@ff380000` is `mmc0` and matches the external slot.
- `mmc@ff370000` is `mmc1` and matches the system card host.
- Both MMC nodes in the shipped Arch-R DTB are configured for 150 MHz and UHS modes.

Resolved dependencies:

- `vmmc-supply = vcc_sd` -> `LDO_REG6`
- `vqmmc-supply = vccio_sd` -> `LDO_REG5`
- `cd-gpios` for `mmc@ff380000` uses `gpio@ff270000` line 14, active-low
- `cd-gpios` for `mmc@ff370000` uses `gpio@ff040000` line 3, active-low

Observed failure on the external slot:

- `mmc_host mmc0: Timeout sending command (cmd 0x202000 arg 0x0 status 0x80202000)`
- `mmc0: error -110 whilst initialising SD card`

## 4. Focused comparison table

| Item | dArkOS SD2 fix | Arch-R shipped DTB |
|---|---|---|
| Target node | External SD host, i.e. `mmc0` / `mmc@ff380000` | `mmc0` / `mmc@ff380000` |
| `max-frequency` | `50000000` | `150000000` (`0x8f0d180`) |
| `sd-uhs-sdr12` | removed | present |
| `sd-uhs-sdr25` | removed | present |
| `sd-uhs-sdr50` | removed | present |
| `sd-uhs-sdr104` | removed | present |
| `cap-sd-highspeed` | retained | present |
| `bus-width` | unchanged by patch intent | `4` |
| `cd-gpios` | unchanged by patch intent | GPIO on `gpio@ff270000` line 14, active-low |
| `vmmc-supply` | unchanged by patch intent | `vcc_sd` (`LDO_REG6`) |
| `vqmmc-supply` | unchanged by patch intent | `vccio_sd` (`LDO_REG5`) |
| Current behavior | would force legacy-high-speed only | currently times out during card init |

## 5. Verdict

`applicable with adaptation`

Reasoning:

- The dArkOS fix is semantically valid for the Arch-R DTB because Arch-R still exposes the same external SD host structure and still advertises 150 MHz plus UHS modes on `mmc@ff380000`.
- The exact node to change on Arch-R is clear from live mapping: `mmc0 -> mmc@ff380000`.

## 6. Evidence inventory

Console files collected:

- `/flash/dtbs/rk3326-gameconsole-r36s.dtb`
- `/proc/cmdline`
- `/sys/class/mmc_host/mmc0/device/of_node`
- `/sys/class/mmc_host/mmc1/device/of_node`
- `dmesg` lines matching `mmc0|mmc1|mmc_host|mmcblk`

Repository files created:

- `r36s-ArchR-fixtures/dumps/dtb/rk3326-gameconsole-r36s.dtb`
- `r36s-ArchR-fixtures/dumps/dtb/rk3326-gameconsole-r36s.dts`
- `r36s-ArchR-fixtures/dumps/dmesg/proc-cmdline.txt`
- `r36s-ArchR-fixtures/dumps/dmesg/boot-config-files.txt`
- `r36s-ArchR-fixtures/dumps/dmesg/mmc-dmesg.txt`
- `r36s-ArchR-fixtures/research/sd2/darkos-patch-applicability.md`