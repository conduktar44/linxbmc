 #
 # build_chroot.sh for 32-bit AppleTV
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

echo "deb http://archive.ubuntu.com/ubuntu/ precise main universe multiverse 
deb http://archive.ubuntu.com/ubuntu/ precise-security main universe multiverse 
deb http://archive.ubuntu.com/ubuntu/ precise-updates main universe multiverse " > /etc/apt/sources.list

echo Installing APT dependencies

apt-get update

if [ "$?" != 0 ]; then echo Could not update apt, probably no network activity && exit 1; fi

PACKAGES="
autopoint
build-essential
git-core
gawk
pmount
libtool
nasm
yasm
automake
cmake
gperf
zip
unzip
bison
libsdl-dev
libsdl-image1.2-dev
libsdl-gfx1.2-dev
libsdl-mixer1.2-dev
libfribidi-dev
liblzo2-dev
libfreetype6-dev
libsqlite3-dev
libogg-dev
libasound2-dev
python-sqlite
libglew-dev
libcurl3
libcurl4-gnutls-dev
libxrandr-dev
libxrender-dev
libmad0-dev
libogg-dev
libvorbisenc2
libsmbclient-dev
libmysqlclient-dev
libpcre3-dev
libdbus-1-dev
libhal-dev
libhal-storage-dev
libjasper-dev
libfontconfig-dev
libbz2-dev
libboost-dev
libenca-dev
libxt-dev
libxmu-dev
libpng-dev
libjpeg-dev
libpulse-dev
mesa-utils
libcdio-dev
libsamplerate-dev
libmpeg3-dev
libflac-dev
libiso9660-dev
libass-dev
libssl-dev
fp-compiler
gdc
libmpeg2-4-dev
libmicrohttpd-dev
libmodplug-dev
libssh-dev
gettext
cvs
python-dev
libyajl-dev
libboost-thread-dev
libplist-dev
libusb-dev
libudev-dev
libtinyxml-dev
libcap-dev
curl
swig
default-jre
libmp3lame-dev
wget
nano
kpartx
parted
libshairport-dev
libafpclient-dev
libnfs-dev
libbluray-dev
libtinyxml-dev
libsmbclient-dev
"
for package in $PACKAGES
do
  apt-get -y install $package
  if [ $? != 0 ]; then echo Could not install package $package && exit 1; fi
done

echo Installing dpkg dependencies

wget --no-check-certificate https://launchpad.net/~krosswindz/+archive/xbmc-atv/+files/libcrystalhd3_0.0%2Bgit20110314.fdd2f19-ppa1_i386.deb
wget --no-check-certificate https://launchpad.net/~krosswindz/+archive/xbmc-atv/+files/libcrystalhd-dev_0.0%2Bgit20110314.fdd2f19-ppa1_i386.deb
wget --no-check-certificate https://launchpad.net/~pulse-eight/+archive/libcec/+files/libcec2_2.1.1-5%7Eprecise_i386.deb
wget --no-check-certificate https://launchpad.net/~pulse-eight/+archive/libcec/+files/libcec2_2.1.1-5%7Eprecise_i386.deb
wget --no-check-certificate https://launchpad.net/~pulse-eight/+archive/libcec/+files/libcec-dev_2.1.1-5%7Eprecise_i386.deb
wget --no-check-certificate https://launchpad.net/~pulse-eight/+archive/libcec/+files/cec-utils_2.1.1-5%7Eprecise_i386.deb
for package in $(ls *.deb)
do
dpkg -i $package
rm $package
done
apt-get -y -f install

if [ "$?" != 0 ]; then echo Could not install packages via dpkg && exit 1; fi

wget http://atv-bootloader.googlecode.com/files/darwin-cross.tar.gz
tar -xzf darwin-cross.tar.gz
cd darwin-cross
sh install_darwin-cross.sh
if [ "$?" != 0 ]; then echo Could not install Darwin-X tools && exit 1; fi
cd ../
rm darwin-cross.tar.gz

mkdir /tmp/tl
cd /tmp/tl
wget http://mirrors.xbmc.org/build-deps/darwin-libs/taglib-1.8.tar.gz
tar -xzf taglib-1.8.tar.gz
cd taglib-1.8
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_STATIC=1
if [ "$?" != 0 ]; then echo Could not install taglib && exit 1; fi
make install
rm -rf /tmp/tl
