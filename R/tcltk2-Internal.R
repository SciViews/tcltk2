# tcltk2-Internal.R - Hidden functions for tcltk2
# Copyright (c), Philippe Grosjean (phgrosjean@sciviews.org)
#
# TODO:
# - Rework the tile stuff
# - .onUnload() function (unload DLLs etc. but there are no DLLs any more!?)

".onLoad" <-
function(libname, pkgname) {
	libdir <- file.path(libname, pkgname, "tklibs")

	# A slightly modified version of addTclPath() that works also within SciViews
	addTclPath <- function (path = ".") {
		if (.Platform$OS.type == "windows") 
		    path <- gsub("\\\\", "/", path)
		a <- tclvalue(tcl("set", "::auto_path"))
		paths <- strsplit(a, " ", fixed = TRUE)[[1L]]
		if (!path %in% paths) 
		    tcl("lappend", "::auto_path", path)
	}
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
		#tclRequire("combobox")    		# Version 2.3
		#tclRequire("choosefont")       # Version 0.2
		#tclRequire("ctext")			# Version 3.1
		#tclRequire("cursor")       	# Version 0.1
		#tclRequire("mclistbox")    	# Version 1.2
		#Not provided any more -> tclRequire("Tktable")   		# Version 2.9

		# The following code is not implemented as Tcl package... just source it
		tcl("source", file.path(libdir, "notebook1.3", "notebook.tcl"))
	    tcl("source", file.path(libdir, "tree1.7", "tree.tcl"))

		# Do we try to load the tile widgets? (only if Tcl./Tk < 8.5)
		if (as.numeric(.Tcl("set ::tcl_version")) < 8.5) {
#				tcl("source", file.path(libdir, "fonts.tcl"))
				# Define fonts used in Tk (note: must be done AFTER loading tile!)
				## Default values for system fonts are calculated by tile...
				## but they should be computer from the system, actually
				## We collect back those values calculated by tile and possibly override
				## them with better values
#				tk2font.setstyle(system = TRUE, default.styles = TRUE, text = TRUE)
				### TODO: reflect possible changes to other graphical toolkits (how?)
				### TODO: homogenize R console, R graph, SciTe fonts with these fonts
		} else {	# There is a bug in mclistbox with Tcl/Tk 8.5
			# Patch by Christiane Raemsch, slightly modified by Ph. Grosjean
			# This is essentially the listbox procedure, but with an additional
			# focus argument required by mclistbox
			.Tcl('proc ::tk::ListboxBeginSelect {w el {focus 0}} {
				variable ::tk::Priv
				if {[$w cget -selectmode] eq "multiple"} {
					if {[$w selection includes $el]} {
						$w selection clear $el
					} else {
						$w selection set $el
					}
				} else {
					$w selection clear 0 end
					$w selection set $el
					$w selection anchor $el
					set Priv(listboxSelection) {}
					set Priv(listboxPrev) $el
				}
				event generate $w <<ListboxSelect>>
				if {$focus && [winfo exists $w]} {
					focus $w
				}
			}')
		}
	}
	# Try loading addtional ttk themes
	try(tclRequire("ttk::theme::plastik"), silent = TRUE)
	try(tclRequire("ttk::theme::keramik"), silent = TRUE)
	try(tclRequire("ttk::theme::keramik_alt"), silent = TRUE)
	
	# Windows only
    if (.Platform$OS.type == "windows") {
		tclRequire("dde")       # Version 1.2.2
        # Not loaded automatically!
        #tclRequire("registry")  # Version 1.1.3
        if (nzchar(r_arch <- .Platform$r_arch))
			tcl("load", file.path(libname, pkgname, "libs", r_arch, "Winico06.dll"))
		else
			tcl("load", file.path(libname, pkgname, "libs", "Winico06.dll"))
		# Also register the DDE server as TclEval|R
        tk2dde("R")
    } else {
		# Use plastik theme by default
		try(tk2theme("plastik"), silent = TRUE)
	}
}

### TO DO: .onUnload() that close downloaded tk items (or unload Tcl completely?)
# Use package forget and change auto_path, ... or leave like this to avoid
# breaking Tcl?

".Last.lib" <-
function (libpath)
{
    # Remove all currently scheduled tasks
	tclTaskDelete(id = NULL)
}

".TempEnv" <-
function ()
{
    pos <-  match("TempEnv", search())
    if (is.na(pos)) { # Must create it
        TempEnv <- list()
        attach(TempEnv, pos = length(search()) - 1)
        rm(TempEnv)
        pos <- match("TempEnv", search())
    }
    return(pos.to.env(pos))
}

".assignTemp" <-
function (x, value, replace.existing = TRUE)
    if (replace.existing || !exists(x, envir = .TempEnv(), mode = "any",
		inherits = FALSE))
        assign(x, value, envir = .TempEnv())

".getTemp" <-
function (x, default = NULL, mode = "any", item = NULL)
{
    if (is.null(item)) Mode <- mode else Mode <- "any"
    if  (exists(x, envir = .TempEnv(), mode = Mode, inherits = FALSE)) {
        dat <- get(x, envir = .TempEnv(), mode = Mode, inherits = FALSE)
        if (is.null(item)) return(dat) else {
            item <- as.character(item)[1]
            if (inherits(dat, "list") && item %in% names(dat)) {
                dat <- dat[[item]]
                if (mode != "any" && mode(dat) != mode) dat <- default
                return(dat)
            } else {
                return(default)
            }
        }
    } else { # Variable not found, return the default value
        return(default)
    }
}
