 #
 # build.sh for 32-bit AppleTV
 # 
 # Copyright 2013 Sam Nazarko <samnazarko@stmteam.com>
 # 
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation; either version 2 of the License, or
 # (at your option) any later version.
 # 
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 # 
 # You should have received a copy of the GNU General Public License
 # along with this program; if not, write to the Free Software
 # Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 # MA 02110-1301, USA.
 # 
 # 
 #

# Quick environment set up:

TARGET="atvx86"
export INSTALLPATH="/toolchains/$TARGET"
DEBOOTSTRAP_LINE="debootstrap --arch=i386 precise $INSTALLPATH"
CHROOT_FILE="build_chroot.sh"
CHROOT_PRE_PREP="" # This is useful for debootstraps with --foreign
CHROOT_LINE="chroot ${INSTALLPATH} /bin/bash /${CHROOT_FILE}"
VERSION=$(cat version)

. ../../common/chroot-ops.sh
. ../../scripts/build_funcs.sh

# Install tools we need

handle_dep "debootstrap" "/usr/sbin/debootstrap"

# Check if re-build is necessary

sh ../../common/checkbuild.sh "$INSTALLPATH"

if [ "$?" == "0" ]; then echo "Toolchain is up to date" && exit 1; fi

echo Building toolchain for "$TARGET"

if [ -e "$INSTALLPATH" ]; then umount $INSTALLPATH/proc > /dev/null 2>&1; rm -rf "$INSTALLPATH"; fi

mkdir -p "$INSTALLPATH"

$DEBOOTSTRAP_LINE

if [ "$?" != 0 ]; then echo Debootstrap was not successful, exiting && exit 1; fi

echo Installing network

configurenet

mount -t proc proc $INSTALLPATH/proc

$CHROOT_PRE_PREP

cp $CHROOT_FILE $INSTALLPATH

$CHROOT_LINE

if [ "$?" != 0 ] ; then echo Chroot operations not successful, exiting && exit 1; fi

# Clean up the filesystem
umount $INSTALLPATH/proc
cleantarget

# Mark the filesystem as up to date

cp version "$INSTALLPATH/version"

# Create a tarball of the filesystem

tar -czf "linxbmc-buildfs-$target-$VERSION.tar.gz" $INSTALLPATH

if [ "$?" != 0 ]; then echo Could not create tarball filesystem, exiting && exit 1; fi

# Install the filesystem if we are on our webserver

if [ -f /var/www/linxbmc-files/downloads/source/filesystems/ ]
then
echo Installing filesystem to web server
cp "linxbmc-buildfs-$target-$VERSION.tar.gz" /var/www/linxbmc-files/downloads/source/filesystems
fi

# Install to archives
echo "Copied archive to /toolchains/archive as linxbmc-buildfs-$target-$VERSION.tar.gz"
mkdir -p /toolchains/archive > /dev/null 2>&1
mv "linxbmc-buildfs-$TARGET-$VERSION.tar.gz" /toolchains/archive/

exit 0
