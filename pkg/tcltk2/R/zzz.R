# zzz.R - Startup and exit sequences for tcltk2
# Copyright (c), Philippe Grosjean (phgrosjean@sciviews.org)
# Licensed under LGPL 3 or above
#
# Changes:
# - 2009-06-27: elimination of winSystemFonts() because Tcl/Tk 8.5 now correctly
#   initializes system fonts
#
# - 2007-01-01: fisrt version (for tcltk2_1.0-0)
#
# To do:
# - Rework the tile stuff
# - .onUnload() function (unload DLLs etc.)

".onLoad" <-
function(libname, pkgname) {
	libdir <- file.path(libname, pkgname, "tklibs")

    res <- addTclPath(libdir)	# extend the Tcl/Tk path
    ### TODO: add path to bin!
    ### TODO: get windowing system with .Tcl("tk windowingsystem")
    #Yes, .Platform$OS == "unix" in Mac. However, perhaps you're not
	#interested in the OS type, though, but you're interested  in  the type
	#of GUI. .Platform$GUI which is "AQUA" if you run R in the usual
	#graphical UI window, but "X11" if you run R in X11 terminal or bash
	#terminal window (and these really are different beasts GUI-wise).
	#Further, .Platform$pkgType == "mac.binary" in CRAN releases of Mac R
	#(but may be different if users have built R from the source).
	#Function install.packages() uses .Platform$pkgType to detect the platform.

    # Make sure that Tcl/Tk locale is the same one as current R locale
	lang <- getLanguage()
	if (lang != "") {	# Set the same language for Tcl/Tk
		res <- tclRequire("msgcat")
	    if (inherits(res, "tclObj")) tcl("::msgcat::mclocale", lang)
	}

    if (is.tk()) {
		# Here is how we could install the supplementary material in Tcl
		# all available under Windows... other platforms must install separately
		#tclRequire("bwidget")    		# Version 1.7
		#tclRequire("combobox")    		# Version 2.3
		#tclRequire("choosefont")       # Version 0.2
		#tclRequire("ctext")			# Version 3.1
		#tclRequire("cursor")       	# Version 0.1
		#tclRequire("Img")       		# Version 1.3
		#tclRequire("mclistbox")    	# Version 1.2
		#Not provided any more -> tclRequire("Tktable")   		# Version 2.9

		# The following code is not implemented as Tcl package... just source it
		tcl("source", file.path(libdir, "balloon1.2", "balloon.tcl"))
		tcl("source", file.path(libdir, "notebook1.3", "notebook.tcl"))
	    tcl("source", file.path(libdir, "tree1.7", "tree.tcl"))

		# Do we try to load the tile widgets? (only if Tcl./Tk < 8.5)
		if (as.numeric(.Tcl("set tcl_version")) < 8.5) {
			if (is.null(load.tile <- getOption("tcltk2.tile")) || load.tile) {
				tile.load(warn = FALSE)
			} else { # We need to create the fonts as tile would have done it
				tcl("source", file.path(libdir, "fonts.tcl"))
				# Define fonts used in Tk (note: must be done AFTER loading tile!)
				## Default values for system fonts are calculated by tile...
				## but they should be computer from the system, actually
				## We collect back those values calculated by tile and possibly override
				## them with better values
				tk2font.setstyle(system = TRUE, default.styles = TRUE, text = TRUE)
				### TODO: reflect possible changes to other graphical toolkits (how?)
				### TODO: homogenize R console, R graph, SciTe fonts with these fonts
			}
		}
	}
	# Windows only
    if (.Platform$OS.type == "windows") {
		tclRequire("dde")       # Version 1.2.2
        # Not loaded automatically!
        #tclRequire("registry")  # Version 1.1.3
        ### Don't work!? tclRequire("winico")
        tcl("load", file.path(libdir, "winico0.6", "Winico06.dll"))
        # Also register the DDE server as TclEval|R
        tk2dde("R")
    }
}

### TO DO: .onUnload() that close downloaded tk items (or unload Tcl completely?)
