 #
 # checkbuild.sh do we need to rebuild our toolchain
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

if [ -z "$1" ]
then
echo "You didn't pass a toolchain"
exit 1
fi
PATH1=$(pwd)/version
PATH2="$1/version"
if diff $PATH1 $PATH2 > /dev/null 2>&1
then
return 0
else
return 1
fi