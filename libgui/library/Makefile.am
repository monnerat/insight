## Process this file with automake to produce Makefile.in.

AUTOMAKE_OPTIONS = cygnus

## Convenience variables.
TCL = advice.tcl balloon.tcl bbox.tcl bindings.tcl \
canvas.tcl cframe.tcl center.tcl debug.tcl def.tcl internet.tcl	\
font.tcl gensym.tcl gettext.tcl hooks.tcl lframe.tcl list.tcl \
looknfeel.tcl menu.tcl mono.tcl multibox.tcl parse_args.tcl path.tcl \
postghost.tcl prefs.tcl print.tcl sendpr.tcl topbind.tcl toolbar.tcl \
ulset.tcl wframe.tcl wingrab.tcl ventry.tcl combobox.tcl \
pane.tcl panedwindow.tcl

## This directory is also referenced in paths.c, which see.
guidir = $(datadir)/redhat/gui
gui_DATA = tclIndex pkgIndex.tcl $(TCL) $(PACKAGES)


if CROSS_COMPILING
TCLSH = tclsh8.4
else
TCLSH = @TCLSH@
endif

if MAINTAINER_MODE
tclIndex: $(TCL)
	 echo "package require Itcl; auto_mkindex $(LIBGUI_LIBRARY_DIR) $(TCL)" | $(TCLSH)
else
tclIndex:
endif

ETAGS_ARGS = --lang=none --regex='/[ \t]*\(proc\|method\|itcl_class\)[ \t]+\([^ \t]+\)/\1/' $(TCL) --lang=auto
