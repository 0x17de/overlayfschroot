# OverlayFS Chroot
DO NOT USE IN PRODUCTION SYSTEMS / HAVE BACKUPS / DONT START NETWORK SERVICES WITHOUT CONSIDERING SIDE EFFECTS.

## Why?
These scripts can be used to test system upgrades without affecting the original data. Only use them when you made sure this will not break things. Communication to the outside world is still possible - this is just like working on a filesystem snapshot.

## Quick Explanations
The script will mount all directories in the filesystem root (except proc sys dev) via overlayfs into a mnt directory, which will be created in this directory. upper/work/merged directories will be created and passed to the overlayfs mount call.

## Important
These scripts will not protect /dev /proc /sys, as they will be mounted via -R (rebind).
Tools started in the chroot can still communicate with the outside world.

Since /dev is not protected in any way, an upgrade of grub could for example reinstall the bootloader on the real system!

Avoid mounting directories inside the chroot. This could cause unwanted behavior.

## Usage
```sh
mv $REPOROOT /overlayfschroot
cd /overlayfschroot
./mount.sh
# enter the environment
./chroot.sh (will call mount if not done yet)
# unmount all overlayfs mounts and rebinds
./umount.sh
# remove all empty directories (will call umount if not done yet)
./cleanup.sh
# if done with the work you can remove the upper directory and its contents`
```

## Examples
### Building binary packages for gentoo hosts
The following example can be used to predict if updating the system would fail. Additionally one can later install all binary packages without recompiling everything again.

Synchronize the package list before calling the mount script, with for example eix: `eix-sync -q`

Chroot into the system and run:
```sh
mkdir -p /root/binpkgs
PKGDIR="/root/binpkgs" emerge -avuDNqb @world
```
Here the -b flag is used to create binary packages on the fly.

Afterwards exit the chroot and cleanup the files. Inside the remaining upper directory you can find all generated binary packages, which can be quickly installed using the -K flag as follows:
```sh
PKGDIR="/overlayfschroot/upper/root/binpkgs" emerge -avuDNqK @world
```
