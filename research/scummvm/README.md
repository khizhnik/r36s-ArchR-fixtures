# ScummVM Game List Refresh

## Problem

- ScummVM creates launcher files successfully.
- New games do not appear immediately in EmulationStation.
- The user has to restart the frontend to see the refreshed list.

## Why it was happening

- The scan launcher already creates the `.scummvm` files correctly.
- EmulationStation caches the game list while it is running.
- The frontend does not automatically rescan after the scan script finishes.

## Solution

After:

```bash
bash /usr/bin/start_scummvm.sh create
```

the launcher calls:

```bash
curl --connect-timeout 2 --max-time 5 -fsS http://localhost:1234/reloadgames
```

If refresh fails, the script shows a short fallback message and pauses briefly so the user can read it.

## Why this works

- EmulationStation caches the game list in memory.
- Launcher generation succeeds before the refresh step runs.
- `/reloadgames` performs an in-process refresh through an existing HTTP API.
- That means no frontend restart is required for the new games to appear.

## Upstream note

This patch does not introduce a new refresh mechanism.
It simply reuses the existing EmulationStation HTTP API exposed by `/reloadgames`.

## Files

### `files/_Scan ScummVM Games.sh`

Ready-to-use version of the launcher script for users who want to copy the full file.

### `patches/scummvm-scan-refresh.patch`

Minimal patch for maintainers and anyone who prefers to apply the change as a diff.

## How to use it

Backup first:

```bash
cp "/storage/.config/scummvm/games/_Scan ScummVM Games.sh" \
   "/storage/.config/scummvm/games/_Scan ScummVM Games.sh.bak"
```

Copy the prepared file:

```bash
cp "files/_Scan ScummVM Games.sh" \
   "/storage/.config/scummvm/games/_Scan ScummVM Games.sh"

chmod 755 \
   "/storage/.config/scummvm/games/_Scan ScummVM Games.sh"
```

## TODO

- find the upstream `scummvmsa` source tree;
- prepare an upstream PR;
- check whether `/reloadgames` can help other launcher generators.
