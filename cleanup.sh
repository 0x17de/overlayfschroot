#!/bin/bash
cd "$(dirname "$0")"

./umount.sh

find mnt work upper merged -type d -empty -delete
