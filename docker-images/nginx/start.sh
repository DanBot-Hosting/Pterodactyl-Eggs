#!/bin/ash
# DanBot Hosting — Pterodactyl Eggs and Docker Images
# Copyright (C) 2020-2026 DanBot Hosting <https://danbot.host>
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# This notice must be preserved in modified versions. See LICENSE.

rm -rf /home/container/tmp/*

echo "Starting PHP-FPM..."
/usr/sbin/php-fpm82 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "Starting Nginx..."
/usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/