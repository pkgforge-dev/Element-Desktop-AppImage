#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME


# upstream uses x86-64 instead of x86_64
case "$ARCH" in
	x86_64) tarball_arch=x86-64;;
	aarch64) tarball_arch=$ARCH;;
esac
TARBALL=https://packages.element.io/desktop/install/linux/glibc-"$tarball_arch"/element-desktop.tar.gz
wget "$TARBALL" -O /tmp/tarball.tar.gz
tar xfv /tmp/tarball.tar.gz
echo ./element-desktop-* | awk -F'-' '{print $NF; exit}' ~/version

mkdir -p ./AppDir/bin
mv -v ./element-desktop-*/* ./AppDir/bin
