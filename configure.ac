dnl Autoconf configure script for insight, the GNU debugger GUI.
dnl Copyright (C) 1995-2014 Free Software Foundation, Inc.
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

dnl Determine target OS.
TARGETOS=unix
case "${target_os}" in
interix|winnt*|cygwin|msys|mingw*|mks)
	TARGETOS=win;;
macos*)
	TARGETOS=macosx;;
esac
AC_SUBST([TARGETOS])

dnl Check if using the bundled tcl/tk/itcl/itk/iwidgets.
AC_ARG_ENABLE([bundled-tcl],
    [--disable-bundled-tcl to use system installed tcl],,
    [enable_bundled_tcl=yes]) dnl
if test "${enable_bundled_tcl}" != no
then	with_tclinclude="`pwd`/bundle/tcl/generic"
	with_tcl="`pwd`/bundle/tcl/${TARGETOS}"
fi
AC_ARG_ENABLE([bundled-tk],
    [--disable-bundled-tk to use system installed tk],,
    [enable_bundled_tk=yes]) dnl
if test "${enable_bundled_tk}" != no
then	with_tkinclude="`pwd`/bundle/tk/generic"
	with_tk="`pwd`/bundle/tk/${TARGETOS}"
fi
AC_ARG_ENABLE([bundled-itcl],
    [--disable-bundled-itcl to use system installed itcl],,
    [enable_bundled_itcl=yes]) dnl
AC_ARG_ENABLE([bundled-itk],
    [--disable-bundled-itk to use system installed itk],,
    [enable_bundled_itk=yes]) dnl
AC_ARG_ENABLE([bundled-iwidgets],
    [--disable-bundled-iwidgets to use system installed iwidgets],,
    [enable_bundled_iwidgets=yes]) dnl

dnl Add configure options according to enabled bundles.
test "${with_tcl}" &&
	CONFARGS="${CONFARGS} --with-tcl=${with_tcl}"
test "${with_tclinclude}" &&
	CONFARGS="${CONFARGS} --with-tclinclude=${with_tclinclude}"
test "${with_tk}" &&
	CONFARGS="${CONFARGS} --with-tk=${with_tk}"
test "${with_tkinclude}" &&
	CONFARGS="${CONFARGS} --with-tkinclude=${with_tkinclude}"
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

if test "${enable_bundled_tcl}" != no
then	cp -a tcl bundle/
else	rm -rf bundle/tcl
fi

if test "${enable_bundled_tk}" != no
then	cp -a tk bundle/
else	rm -rf bundle/tk
fi

if test "${enable_bundled_itcl}" != no
then	cp -a itcl bundle/
else	rm -rf bundle/itcl
fi

if test "${enable_bundled_itk}" != no
then	cp -a itk bundle/
else	rm -rf bundle/itk
fi

if test "${enable_bundled_iwidgets}" != no
then	cp -a iwidgets bundle/
else	rm -rf bundle/iwidgets
fi

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
if test "${enable_bundled_tcl}" != no
then	(
		cd bundle/tcl/"${TARGETOS}";
		echo "Regenerate `pwd`"
		aclocal -I . -I ../../config
		autoconf --force
	)
fi
if test "${enable_bundled_tk}" != no
then	(
		cd bundle/tk/"${TARGETOS}"
		echo "Regenerate `pwd`"
		aclocal -I . -I ../../config
		autoconf --force
	)
fi
if test "${enable_bundled_itcl}" != no
then	(
		cd bundle/itcl
		echo "Regenerate `pwd`"
		ln -s -f itclWidget/tclconfig ./
		autoconf --force
	)
fi
if test "${enable_bundled_itk}" != no
then	(
		cd bundle/itk
		echo "Regenerate `pwd`"
		ln -s -f ../itcl/itclWidget/tclconfig ./
		autoconf --force
	)
fi

dnl Prepare to configure in the bundle directory.
AC_CONFIG_COMMANDS([config_bundle],
	[(cd bundle; ./configure ${CONFARGS}; )],[CONFARGS="${CONFARGS}"]) dnl
AC_OUTPUT dnl
