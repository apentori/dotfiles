#!/usr/bin/env bash
# This Script prepare an archived from different directories to backup files

BACKUP_DIRS="/home/irotnep/Documents/invoice /home/irotnep/Documents/personnal /home/irotnep/Documents/notes"
BACKUP_PATH="/tmp/backup.tar.gz"

rm $BACKUP_PATH

tar -czvf ${BACKUP_PATH} ${BACKUP_DIRS}

rclone copy /tmp/backup.tar.gz proton:rclone
