#!/bin/bash
cd "$(dirname "$0")"

for i in mnt/*; do
  [ -L "$i" ] && rm "$i" && continue
  mountpoint "$i">&/dev/null || continue
  [[ "$(basename "$i")" =~ ^(sys|proc|dev)$ ]] && umount -l "$i" && continue
  umount "$i"
  rmdir "$i"
done
for i in dev proc sys; do
  rmdir mnt/$i
done
