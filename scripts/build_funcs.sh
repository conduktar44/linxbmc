 #
 # build_funcs.sh for common build functions
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

function install_dep()
{
	echo Attempting to install "$1" via APT
	apt-get update
	apt-get -y install "$1"
}

function handle_dep()
{
	# Checks for dependency existence and will install via apt if necessary
	if [ ! -z $2 ]
	then
		# Check for binary path
		if [ ! -f "$2" ] 
		then install_dep "$1"
		fi
	else
	install_dep "$1"
	fi
}

export handle_dep
