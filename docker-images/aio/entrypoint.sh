#!/bin/bash
# DanBot Hosting — Pterodactyl Eggs and Docker Images
# Copyright (C) 2020-2026 DanBot Hosting <https://danbot.host>
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# This notice, and the attribution printed in the banner below, must be
# preserved in modified versions. See LICENSE.

sleep 3

cd /home/container

echo "=========================================================================================================="
echo "██████╗░░█████╗░███╗░░██╗██████╗░░█████╗░████████╗  ██╗░░██╗░█████╗░░██████╗████████╗██╗███╗░░██╗░██████╗░"
echo "██╔══██╗██╔══██╗████╗░██║██╔══██╗██╔══██╗╚══██╔══╝  ██║░░██║██╔══██╗██╔════╝╚══██╔══╝██║████╗░██║██╔════╝░"
echo "██║░░██║███████║██╔██╗██║██████╦╝██║░░██║░░░██║░░░  ███████║██║░░██║╚█████╗░░░░██║░░░██║██╔██╗██║██║░░██╗░"
echo "██║░░██║██╔══██║██║╚████║██╔══██╗██║░░██║░░░██║░░░  ██╔══██║██║░░██║░╚═══██╗░░░██║░░░██║██║╚████║██║░░╚██╗"
echo "██████╔╝██║░░██║██║░╚███║██████╦╝╚█████╔╝░░░██║░░░  ██║░░██║╚█████╔╝██████╔╝░░░██║░░░██║██║░╚███║╚██████╔╝"
echo "╚═════╝░╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░░╚════╝░░░░╚═╝░░░  ╚═╝░░╚═╝░╚════╝░╚═════╝░░░░╚═╝░░░╚═╝╚═╝░░╚══╝░╚═════╝░"
echo "========================================== All Rights Reserved ==========================================="
echo "====================================== Support: dibster@danbot.host ======================================"
echo "=========================================================================================================="
echo "Installed Versions:"
echo "Node.js:  $(node -v 2>/dev/null)"
echo "npm:      $(npm -v 2>/dev/null)"
echo "yarn:     $(yarn -v 2>/dev/null)"
echo "PM2:      $(pm2 -v 2>/dev/null | tail -n 1)"
echo "pnpm:     $(pnpm -v 2>/dev/null)"
echo "Java:     $(java -version 2>&1 | head -n 1)"
echo "Python:   $(python3 --version 2>/dev/null)"
echo "Pip:      $(pip3 --version 2>/dev/null)"
echo "Go:       $(go version 2>/dev/null)"
echo "======================================== SERVER MARKED AS RUNNING ========================================"


# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}