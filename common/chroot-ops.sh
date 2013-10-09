 #
 # chroot-ops.sh for common chroot operation preparation
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

function configurenet()
{
	echo Installing network configuration from host
	cp /etc/resolv.conf "$INSTALLPATH"/etc/resolv.conf
	cp /etc/network/interfaces "$INSTALLPATH"/etc/network/interfaces
}

function cleantarget()
{
	echo Cleaning up new filesystem
	rm "$INSTALLPATH"/etc/resolv.conf > /dev/null 2>&1
	rm "$INSTALLPATH"/etc/network/interfaces > /dev/null 2>&1
	rm -rf "$INSTALLPATH"/usr/share/doc/*
	rm -rf "INSTALLPATH"/usr/share/man/* 
	rm -rf "INSTALLPATH"/var/cache/apt/archives/*
}

export configurenet
export cleantarget
