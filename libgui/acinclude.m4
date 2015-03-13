sinclude(../config/tcl.m4)

dnl Find the location of the private Tcl headers
dnl This is TCL_INCLUDE_SPEC/tcl-private/generic or TCL_SRC_DIR/generic.
dnl As a side effect, determine the TCL platform.
dnl
dnl Note: you must use first use SC_LOAD_TCLCONFIG!
AC_DEFUN([CY_AC_TCL_PRIVATE_HEADERS], [
  AC_MSG_CHECKING([for Tcl private headers])
  private_dir=""
  for dir in "${TCL_INCLUDE_SPEC}/tcl-private" "${TCL_SRC_DIR}"; do
    dir=`echo "${dir}/generic" | sed -e s/-I//`
    if test -f "${dir}/tclInt.h"; then
      private_dir="${dir}"
      break
    fi
  done

  if test x"${private_dir}" = x; then
    AC_ERROR(could not find private Tcl headers)
  else
    TCL_PRIVATE_INCLUDE="-I${private_dir}"
    AC_MSG_RESULT(${private_dir})
    TCL_PLATFORM=unknown
    dir="`dirname \"${private_dir}\"`"
    for platform in Unix Win MacOSX; do
      # FIXME: actually, MacOSX is not detected. How to do it ?
      pf="`echo \"${platform}\" | tr 'A-Z' 'a-z'`"
      if test -f "${dir}/generic/tcl${platform}Port.h"; then
        TCL_PLATFORM="${pf}"
        break
      elif test -f "${dir}/${pf}/tcl${platform}Port.h"; then
        TCL_PLATFORM="${pf}"
        TCL_PRIVATE_INCLUDE="${TCL_PRIVATE_INCLUDE} -I${dir}/${pf}"
        break
      fi
    done
  fi
])

dnl Find the location of the private Tk headers
dnl This is TK_INCLUDE_SPEC/tk-private/generic or TK_SRC_DIR/generic.
dnl
dnl Note: you must first use SC_LOAD_TKCONFIG
AC_DEFUN([CY_AC_TK_PRIVATE_HEADERS], [
  AC_MSG_CHECKING([for Tk private headers])
  private_dir=""
  for dir in "${TK_INCLUDE_SPEC}/tk-private" "${TK_SRC_DIR}"; do
    dir=`echo "${dir}/generic" | sed -e s/-I//`
    if test -f "${dir}/tkInt.h"; then
      private_dir="${dir}"
      break
    fi
  done

  if test x"${private_dir}" = x; then
    AC_ERROR(could not find Tk private headers)
  else
    TK_PRIVATE_INCLUDE="-I${private_dir}"
    AC_MSG_RESULT(${private_dir})
    TK_PLATFORM=unknown
    dir="`dirname \"${private_dir}\"`"
    for platform in Unix Win MacOSX; do
      pf="`echo \"${platform}\" | tr 'A-Z' 'a-z'`"
      if test -f "${dir}/generic/tk${platform}Port.h"; then
        TK_PLATFORM="${pf}"
        break
      elif test -f "${dir}/${pf}/tk${platform}Port.h"; then
        TK_PLATFORM="${pf}"
        TK_PRIVATE_INCLUDE="${TK_PRIVATE_INCLUDE} -I${dir}/${pf}"
        break
      fi
    done
  fi
])
