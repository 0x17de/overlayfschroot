#!/bin/bash
cd "$(dirname "$0")"

[ ! -f mnt ] && ./mount.sh
chroot mnt bash
