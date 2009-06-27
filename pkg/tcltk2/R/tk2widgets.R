# tk2widgets.R - Support for the tile Tk widgets
# Copyright (c), Philippe Grosjean (phgrosjean@sciviews.org)
# Licensed under LGPL 3 or above
#
# Changes:
# - 2007-01-01: fisrt version (for tcltk2_1.0-0)
#
# To do:
# - Rework all this and add new widgets like sizegrip, tkplot, centry, ...

"tk2button" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Tcl package 'Tk' is required but not loaded")
	if (use.tile) {
		if (!is.tile()) stop("Tcl package 'tile' is required but not loaded")
		w <- tkwidget(parent, "ttk::button", ...)
		class(w) <- c("ttk2button", "tk2widget", class(w))
	} else { # Default Tk button widget with font set to TkDefaultFont
		w <- tkwidget(parent, "button", font = "TkDefaultFont", ...)
		class(w) <- c("tk2button", "tk2widget", class(w))
	}
	if (tip != "") tk2tip(w, tip)
	return(w)
}

"tk2canvas" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	w <- tkwidget(parent, "canvas", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2canvas", "tk2widget", class(w))
	return(w)
}

"tk2checkbutton" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	# TODO: associate with a variable and set both states values
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (use.tile) {
		w <-tkwidget(parent, "ttk::checkbutton", ...)
		class(w) <- c("ttk2checkbutton", "tk2widget", class(w))
	} else {
		w <- tkwidget(parent, "checkbutton", font = "TkDefaultFont", ...)
		class(w) <- c("tk2checkbutton", "tk2widget", class(w))
	}
	if (tip != "") tk2tip(w, tip)
	return(w)
}

"tk2combobox" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	# TODO: associate the list and results with a variable and intialize the widget
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (use.tile) {
		w <- tkwidget(parent, "ttk::combobox", ...)
		class(w) <- c("ttk2combobox", "tk2widget", class(w))
	} else {
		res <- tclRequire("combobox")
		if (!inherits(res, "tclObj"))
			stop("Impossible to load the Tcl combobox package; check your Tcl/Tk installation")
		w <- tkwidget(parent, "combobox::combobox", font = "TkDefaultFont", ...)
		class(w) <- c("tk2combobox", "tk2widget", class(w))
	}
	if (tip != "") tk2tip(w, tip)
	return(w)
}

### TODO: a centry widget
"tk2entry" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	### TODO: add cut/copy/paste/select all/clear context menu
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (use.tile) {
		w <- tkwidget(parent, "ttk::entry", cursor = "xterm", ...)
		class(w) <- c("ttk2entry", "tk2widget", class(w))
	} else {
		w <- tkwidget(parent, "entry", font = "TkTextFont", ...)
		class(w) <- c("tk2entry", "tk2widget", class(w))
	}
	if (tip != "") tk2tip(w, tip)
	return(w)
}

"tk2frame" <-
function(parent, use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (use.tile) {
		w <- tkwidget(parent, "ttk::frame", ...)
		class(w) <- c("ttk2frame", "tk2widget", class(w))
	} else {
		w <- tkwidget(parent, "frame", ...)
		class(w) <- c("tk2frame", "tk2widget", class(w))
	}
	return(w)
}

"tk2label" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (use.tile) {
		w <- tkwidget(parent, "ttk::label", ...)
		class(w) <- c("ttk2label", "tk2widget", class(w))
	} else {
		w <- tkwidget(parent, "label", font = "TkDefaultFont", ...)
		class(w) <- c("tk2label", "tk2widget", class(w))
	}
	if (tip != "") tk2tip(w, tip)
	return(w)
}

"tk2labelframe" <-
function(parent, use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (use.tile) {
		w <- tkwidget(parent, "ttk::labelframe", ...)
		class(w) <- c("ttk2labelframe", "tk2widget", class(w))
	} else {
		w <- tkwidget(parent, "labelframe", font = "TkDefaultFont", ...)
		class(w) <- c("tk2labelframe", "tk2widget", class(w))
	}
	return(w)
}

"tk2listbox" <-
function(parent, selectmode = c("single", "browse", "multiple", "extended"),
tip = "", use.tile = is.tile(), ...) {
	### TODO: associate list and selection with a variable and configure the list
	### TODO: autohiding scrollbars
	if (!is.tk()) stop("Package Tk is required but not loaded")
	selectmode <- as.character(selectmode[1])
	# There is no tile version of this widget, but we configure it slightly differently
	if (use.tile) {
		w <- tkwidget(parent, "listbox", font = "TkDefaultFont",
		borderwidth = 0, selectmode = selectmode, exportselection = 0, ...)
	} else {
		w <- tkwidget(parent, "listbox", font = "TkDefaultFont",
		selectmode = selectmode, exportselection = 0, ...)
	}
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2listbox", "tk2widget", class(w))
	return(w)
}

"tk2mclistbox" <-
function(parent, tip ="", use.tile = is.tile(), ...) {
	### TODO: a tile equivalent of this widget
	### TODO: or adjust the header: font, color and frame
	if (!is.tk()) stop("Package Tk is required but not loaded")
	res <- tclRequire("mclistbox")
	if (!inherits(res, "tclObj"))
		stop("Impossible to load the Tcl mclistbox package; check your Tcl/Tk installation")
	w <- tkwidget(parent, "mclistbox::mclistbox", font = "TkDefaultFont", ...)
	if (use.tile) tkconfigure(w, relief = "flat")
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2mclistbox", "tk2widget", class(w))
	return(w)
}

"tk2menu" <-
function(parent, use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	w <- tkwidget(parent, "menu", ...)
	class(w) <- c("tk2menu", "tk2widget", class(w))
	return(w)
}

"tk2menubutton" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (use.tile) {
		w <- tkwidget(parent, "ttk::menubutton", ...)
	} else { # Default Tk button widget with font set to TkDefaultFont
		w <- tkwidget(parent, "menubutton", font = "TkDefaultFont", ...)
	}
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2menubutton", "tk2widget", class(w))
	return(w)
}

"tk2message" <-
function(parent, text = "", justify = c("left", "center", "right"),
width = -1, aspect = 150, tip = "", use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	justify <- as.character(justify[1])
	# No distinction between tile or Tk widgets here
	w <- tkwidget(parent, "message", text = text, justify = justify,
		width = width, aspect = aspect, font = "TkDefaultFont", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2message", "tk2widget", class(w))
	return(w)
}

### TODO: homogenize commands between tile and the pure Tcl notebook
#         and not tile notebook does not work well
"tk2notebook" <-
function(parent, tabs, use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (use.tile) {
		w <- tkwidget(parent, "ttk::notebook", ...)
		# Add pages
		tabs <- as.character(tabs)
		for (tab in tabs) {
			tframe <- tk2frame(w)
			tkadd(w, tframe, text = tab, sticky = "nsew")
		}
		tk2notetraverse(w)	# Enable keyboard traversal for this notebook
		class(w) <- c("ttk2notebook", "tk2widget", class(w))
	} else {
		w <- tkwidget(parent, "Notebook:create", font = "TkDefaultFont", ...)
		# Add pages
		pages <- paste("{", as.character(tabs), "}", sep = "", collapse = " ")
		pages <- paste("{", pages, "}", sep = "")
		.Tcl(paste("Notebook:config", w$ID, "-pages", pages))
		# Select first page, to redraw the notebook correctly
		.Tcl(paste("Notebook:raise.page", w$ID, "0"))
		class(w) <- c("tk2notebook", "tk2widget", class(w))
	}
	return(w)
}

"tk2panedwindow" <-
function(parent, orientation = c("horizontal", "vertical"),
use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	orientation <- as.character(orientation[1])
### TODO: this does not work any more
#	if (use.tile) {
#		w <- tkwidget(parent, "ttk::paned", orient = orientation, ...)
#		class(w) <- c("ttk2panedwindow", "tk2widget", class(w))
#	} else {
		w <- tkwidget(parent, "panedwindow", orient = orientation,
			bd = 0, sashrelief = "groove", ...)
		class(w) <- c("tk2panedwindow", "tk2widget", class(w))
#	}
	return(w)
}

"tk2progress" <-
function(parent, orientation = c("horizontal", "vertical"),
tip = "", use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	orientation <- as.character(orientation[1])
	### TODO: set better colors for non tile widget (according to system colors)
	if (use.tile) {
		w <- tkwidget(parent, "ttk::progressbar", ...)
		class(w) <- c("ttk2progress", "tk2widget", class(w))
	} else { # We use the progressbar from the bwidget
		### TODO: check this, because I was unable to load bwidget
		res <- tclRequire("bwidget")
		if (!inherits(res, "tclObj"))
			stop("Impossible to load the Tcl bwidget package; check your Tcl/Tk installation")
		w <- tkwidget(parent, "progressbar", ...)
		class(w) <- c("tk2progress", "tk2widget", class(w))
	}
	if (tip != "") tk2tip(w, tip)
	return(w)
}

"tk2radiobutton" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	# TODO: associate with a variable and set both states values
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (use.tile) {
		w <-tkwidget(parent, "ttk::radiobutton", ...)
		class(w) <- c("ttk2radiobutton", "tk2widget", class(w))
	} else {
		w <- tkwidget(parent, "radiobutton", font = "TkDefaultFont", ...)
		class(w) <- c("tk2radiobutton", "tk2widget", class(w))
	}
	if (tip != "") tk2tip(w, tip)
	return(w)
}

"tk2scale" <-
function(parent, orientation = c("horizontal", "vertical"),
tip = "", use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	orientation <- as.character(orientation[1])
	### TODO: set better colors for non tile widget (according to system colors)
	if (use.tile) {
		w <- tkwidget(parent, "ttk::scale", orient = orientation, ...)
		class(w) <- c("ttk2scale", "tk2widget", class(w))
	} else { # Do not show value, to better match tile equivalent
		w <- tkwidget(parent, "scale", orient = orientation, showvalue = 0, ...)
		class(w) <- c("tk2scale", "tk2widget", class(w))
	}
	if (tip != "") tk2tip(w, tip)
	return(w)
}

"tk2scrollbar" <-
function(parent, orientation = c("horizontal", "vertical"),
use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	orientation <- as.character(orientation[1])
	if (use.tile) {
		w <- tkwidget(parent, "ttk::scrollbar", orient = orientation, ...)
		class(w) <- c("ttk2scrollbar", "tk2widget", class(w))
	} else {
		w <- tkwidget(parent, "scrollbar", orient = orientation, ...)
		class(w) <- c("tk2scrollbar", "tk2widget", class(w))
	}
	return(w)
}

"tk2separator" <-
function(parent, orientation = c("horizontal", "vertical"),
use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	orientation <- as.character(orientation[1])
	if (use.tile) {
		w <-tkwidget(parent, "ttk::separator", orient = orientation, ...)
		class(w) <- c("ttk2separator", "tk2widget", class(w))
	} else { # We simulate a separator with an empty label
		### TODO...
		w <- tkwidget(parent, "label", ...)
		class(w) <- c("tk2separator", "tk2widget", class(w))
	}
	return(w)
}

"tk2spinbox" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (use.tile) {
		### TODO: construct the tile equivalent to this widget!
		w <- tkwidget(parent, "spinbox", font = "TkDefaultFont",
		relief = "solid", borderwidth = 1, ...)
	} else {
		w <- tkwidget(parent, "spinbox", font = "TkDefaultFont", ...)
	}
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2spinbox", "tk2widget", class(w))
	return(w)
}

"tk2table" <-
function(parent, use.tile = is.tile(), ...) {
	### TODO: a pure Tcl equivalent
	### TODO: a tile equivalent (some customization, if possible)
	if (!is.tk()) stop("Package Tk is required but not loaded")
	if (inherits(tclRequire("Tktable", warn = FALSE), "tclObj")) {
		w <- tkwidget(parent, "table", font = "TkDefaultFont", ...)
		class(w) <- c("tk2table", "tk2widget", class(w))
		return(w)
	} else stop("Tcl package 'Tktable' must be installed first")
}

"tk2text" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	### TODO: autohide scrollbars
	if (!is.tk()) stop("Package Tk is required but not loaded")
	w <- tkwidget(parent, "text", font = "TkTextFont", ...)
	if (use.tile) tkconfigure(w, relief = "flat")
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2text", "tk2widget", class(w))
	return(w)
}

"tk2ctext" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	### TODO: autohide scrollbars
	if (!is.tk()) stop("Package Tk is required but not loaded")
	tclRequire("ctext")
	w <- tkwidget(parent, "ctext", font = "TkFixedFont", ...)
	if (use.tile) tkconfigure(w, relief = "flat")
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2ctext", "tk2widget", class(w))
	return(w)
}

"tk2tree" <-
function(parent, tip = "", use.tile = is.tile(), ...) {
	### TODO: better icons!
	# Reasonable default icons for files and folders
	if (!is.tk()) stop("Package Tk is required but not loaded")
	images <- as.character(tcl("image", "names"))
	if (!"Tree:dir" %in% images)
		.Tcl("image create photo Tree:dir -data {R0lGODdhEAAQAPIAAAAAAHh4eLi4uPj4APj4+P///wAAAAAAACwAAAAAEAAQAAADPVi63P4wLkKCtTTnUsXwQqBtAfh910UU4ugGAEucpgnLNY3Gop7folwNOBOeiEYQ0acDpp6pGAFArVqthQQAO///}")
	if (!"Tree:file" %in% images)
		.Tcl("image create photo Tree:file -data {R0lGODdhEAAQAPIAAAAAAHh4eLi4uPj4+P///wAAAAAAAAAAACwAAAAAEAAQAAADPkixzPODyADrWE8qC8WN0+BZAmBq1GMOqwigXFXCrGk/cxjjr27fLtout6n9eMIYMTXsFZsogXRKJf6uP0kCADv/}")

	### TODO: correct support of font
	w <- tkwidget(parent, "Tree:create") #, font = "TkDefaultFont", ...)
	if (use.tile) tkconfigure(w, relief = "flat")
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2tree", "tk2widget", class(w))
	return(w)
}
