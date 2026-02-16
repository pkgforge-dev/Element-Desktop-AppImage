#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm nspr nss

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

# for x86_64 upstream names the directory element-desktop-1.12.10
# while for aarch64 the directory is named element-desktop-1.12.10-arm64
case "$ARCH" in
	x86_64)  echo ./element-desktop-* | awk -F'-' '{print $NF; exit}'     > ~/version;;
	aarch64) echo ./element-desktop-* | awk -F'-' '{print $(NF-1); exit}' > ~/version;;
esac

mkdir -p ./AppDir/bin
mv -v ./element-desktop-*/* ./AppDir/bin
