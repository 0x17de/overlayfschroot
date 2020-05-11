#!/bin/bash
cd "$(dirname "$0")"

ROOTDIRS=($(find / -mindepth 1 -maxdepth 1 -type d -or -type l | tr -d '/' | grep -v -e sys -e proc -e dev -e overlayupgrade))
SPECIALDIRS=(mnt work merged upper)


function overlaymount() {
  local D=$1
  mountpoint "${PWD}/mnt/$D">&/dev/null || mount -t overlay overlay -o lowerdir="/${D}",upperdir="${PWD}/upper/$D",workdir="${PWD}/work/$D" "${PWD}/mnt/$D"
}


for D in "${SPECIALDIRS[@]}"; do
  mkdir -p $D
done


for D in "${ROOTDIRS[@]}"; do
  [ -L "/$D" ] && [ ! -L "mnt/$D" ] && cp -a /$D mnt/$D && continue
  for S in "${SPECIALDIRS[@]}"; do
    mkdir -p "${S}/${D}"
  done
  overlaymount "$D"
done

for D in dev proc sys; do
  mkdir -p "mnt/${D}"
  mountpoint "${PWD}/mnt/$D">&/dev/null || mount -R "/$D" "${PWD}/mnt/$D"
done

