#!/bin/bash
# DanBot Hosting — Pterodactyl Eggs and Docker Images
# Copyright (C) 2020-2026 DanBot Hosting <https://danbot.host>
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# This notice must be preserved in modified versions. See LICENSE.

sleep 2

cd /home/container

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
