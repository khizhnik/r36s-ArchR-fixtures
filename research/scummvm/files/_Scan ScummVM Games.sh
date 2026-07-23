#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

. /etc/profile

clear
echo "Scanning for games..."

if ! bash /usr/bin/start_scummvm.sh add; then
  echo "ScummVM game scan failed."
  sleep 2
  exit 1
fi

echo "Creating launcher files..."

if ! bash /usr/bin/start_scummvm.sh create; then
  echo "ScummVM launcher creation failed."
  sleep 2
  exit 1
fi

if command -v curl >/dev/null 2>&1 && \
   curl --connect-timeout 2 --max-time 5 -fsS \
     http://localhost:1234/reloadgames >/dev/null 2>&1
then
  echo "ScummVM scan completed."
  echo "EmulationStation game list was refreshed."
else
  echo "ScummVM scan completed."
  echo "EmulationStation game list refresh failed."
  echo "Restart EmulationStation to refresh the game list."
  sleep 2
fi
