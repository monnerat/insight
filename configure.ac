dnl Autoconf configure script for insight, the GNU debugger GUI.
dnl Copyright (C) 1995-2015 Free Software Foundation, Inc.
dnl
dnl This file is part of GDB.
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program.  If not, see <http://www.gnu.org/licenses/>.

dnl Process this file with autoconf to produce a configure script.


AC_PREREQ(2.59) dnl
AC_INIT([insight], [1.0]) dnl

dnl Export original configure arguments for use by sub-configures.
dnl Quote arguments with shell meta charatcers.
CONFARGS=
for ac_arg
do
  case "$ac_arg" in
  *" "*|*"      "*|*[[\[\]\~\#\$\^\&\*\(\)\{\}\\\|\;\<\>\?\']]*)
    ac_arg=`echo "$ac_arg" | sed "s/'/'\\\\\\\\''/g"`
    # if the argument is of the form -foo=baz, quote the baz part only
    ac_arg=`echo "'$ac_arg'" | sed "s/^'\([[-a-zA-Z0-9]]*=\)/\\1'/"` ;;
  *) ;;
  esac
  dnl Add the quoted argument to the list.
  CONFARGS="$CONFARGS $ac_arg"
done
if test "$silent" = yes; then
  CONFARGS="$CONFARGS --silent"
fi

AC_CONFIG_AUX_DIRS(binutils-gdb) dnl
AC_CANONICAL_SYSTEM dnl
AC_DISABLE_OPTION_CHECKING dnl
AC_CONFIG_SRCDIR([gdbtk/generic/gdbtk.c]) dnl
AC_CONFIG_MACRO_DIR([binutils-gdb/config])

CONFARGS="${CONFARGS} --enable-gdbtk"

dnl Remove the initial space we introduced and, as these will be
dnl expanded by make, quote '$'.
CONFARGS=`echo "x$CONFARGS" |
 sed -e 's/^x *//' -e 's,\\$,$$,g'`

dnl Build the bundle directory. 
test -d bundle && chmod -R u+w bundle
cp -a -T binutils-gdb bundle
cp -a gdbtk bundle/gdb/
cp -a testsuite bundle/gdb/
cp -a libgui bundle/

dnl Apply patches
for patchfile in patches/*/*.patch
do	patchdir=`basename \`dirname "${patchfile}"\``
	test "${patchdir}" = binutils-gdb && patchdir=.
	test -d "bundle/${patchdir}" && (
		echo "Applying patch ${patchfile}"
		cd "bundle/${patchdir}"
		patch --no-backup-if-mismatch -p1
	) < "${patchfile}"
done

dnl Configure files
for infn in `cd patches; find . -name '*.in'`
do	outfn=`echo "${infn}" |
	    sed -e 's#^\./##' -e 's/\.in$//' -e 's#^binutils-gdb/##'`
	if test -d bundle/`dirname "${outfn}"`
	then	AC_CONFIG_FILES([bundle/${outfn}:patches/${infn}]) dnl
	fi
done

dnl Since the binutils-gdb configure files have to be regenerated, we define
dnl the autoconf version to use here.
sed -i -e '[/m4\_define(\[_GCC_AUTOCONF_VERSION\],/s/, \[[a-zA-Z0-9._-]*\]/, m4\_PACKAGE_VERSION)/]' bundle/config/override.m4

dnl Now regenerate the configure files
(
	cd bundle
	echo "Regenerate `pwd`"
	autogen Makefile.def
	autoconf --force
)
(
	cd bundle/gdb
	echo "Regenerate `pwd`"
	aclocal -I . -I ../config
	autoconf --force
)
(
	cd bundle/gdb/gdbtk/plugins
	echo "Regenerate `pwd`"
	aclocal -I . -I ../../../config
	automake
	autoconf --force
)
(
	cd bundle/libgui
	echo "Regenerate `pwd`"
	aclocal -I . -I ../config
	automake
	autoconf --force
)

dnl Prepare to configure in the bundle directory.
AC_CONFIG_COMMANDS([config_bundle],
	[(cd bundle; ./configure ${CONFARGS}; )],[CONFARGS="${CONFARGS}"]) dnl
AC_OUTPUT dnl
