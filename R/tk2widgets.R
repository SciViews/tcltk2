# tk2widgets.R - Support for the tile Tk widgets
# Copyright (c), Philippe Grosjean (phgrosjean@sciviews.org)
# Licensed under LGPL 3 or above
#
# Changes:
# - 2009-06-30: only use ttk (no tile or plain widgets)
#
# - 2007-01-01: fisrt version (for tcltk2_1.0-0)
#
# To do:
# - Rework all this and add new widgets like sizegrip, tkplot, ...

"tk2button" <-
function (parent, tip = "", ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "ttk::button", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2button", "tk2widget", class(w))
	return(w)
}

"tk2canvas" <-
function (parent, tip = "", ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	# TODO: use autoscroll here!
	w <- tkwidget(parent, "canvas", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2canvas", "tk2widget", class(w))
	return(w)
}

"tk2checkbutton" <-
function (parent, tip = "", ...)
{
	# TODO: associate with a variable and set both states values
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <-tkwidget(parent, "ttk::checkbutton", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2checkbutton", "tk2widget", class(w))
	return(w)
}

"tk2combobox" <-
function (parent, tip = "", ...)
{
	# TODO: associate the list and results with a variable and intialize the widget
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "ttk::combobox", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2combobox", "tk2widget", class(w))
	return(w)
}

### TODO: a centry widget
"tk2entry" <-
function (parent, tip = "", ...)
{
	### TODO: add cut/copy/paste/select all/clear context menu
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "ttk::entry", cursor = "xterm", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2entry", "tk2widget", class(w))
	return(w)
}

"tk2frame" <-
function (parent, ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "ttk::frame", ...)
	class(w) <- c("tk2frame", "tk2widget", class(w))
	return(w)
}

"tk2label" <-
function (parent, tip = "", ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "ttk::label", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2label", "tk2widget", class(w))
	return(w)
}

"tk2labelframe" <-
function (parent, ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "ttk::labelframe", ...)
	class(w) <- c("ttk2labelframe", "tk2widget", class(w))
	return(w)
}

"tk2listbox" <-
function (parent, selectmode = c("single", "browse", "multiple", "extended"),
tip = "", ...)
{
	### TODO: associate list and selection with a variable and configure the list
	### TODO: autohiding scrollbars
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	selectmode <- as.character(selectmode[1])
	w <- tkwidget(parent, "listbox", font = "TkDefaultFont",
		borderwidth = 0, selectmode = selectmode, exportselection = 0, ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2listbox", "tk2widget", class(w))
	return(w)
}

"tk2mclistbox" <-
function (parent, tip ="", ...)
{
	### TODO: a tile equivalent of this widget
	### TODO: or adjust the header: font, color and frame
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	res <- tclRequire("mclistbox")
	if (!inherits(res, "tclObj"))
		stop("Impossible to load the Tcl mclistbox package; check your Tcl/Tk installation")
	w <- tkwidget(parent, "mclistbox::mclistbox", font = "TkDefaultFont", ...)
	tkconfigure(w, relief = "flat")
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2mclistbox", "tk2widget", class(w))
	return(w)
}

"tk2menu" <-
function (parent, ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "menu", ...)
	class(w) <- c("tk2menu", "tk2widget", class(w))
	return(w)
}

"tk2menubutton" <-
function (parent, tip = "", ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "ttk::menubutton", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2menubutton", "tk2widget", class(w))
	return(w)
}

"tk2message" <-
function (parent, text = "", justify = c("left", "center", "right"),
width = -1, aspect = 150, tip = "", ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	justify <- as.character(justify[1])
	w <- tkwidget(parent, "message", text = text, justify = justify,
		width = width, aspect = aspect, font = "TkDefaultFont", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2message", "tk2widget", class(w))
	return(w)
}

"tk2notebook" <-
function (parent, tabs, ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "ttk::notebook", ...)
	# Add pages
	tabs <- as.character(tabs)
	for (tab in tabs) {
		tframe <- tk2frame(w)
		tkadd(w, tframe, text = tab, sticky = "nsew")
	}
	tk2notetraverse(w)	# Enable keyboard traversal for this notebook
	class(w) <- c("tk2notebook", "tk2widget", class(w))
	return(w)
}

"tk2panedwindow" <-
function (parent, orientation = c("horizontal", "vertical"), ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	orientation <- as.character(orientation[1])
	w <- tkwidget(parent, "ttk::panedwindow", orient = orientation, ...)
	class(w) <- c("tk2panedwindow", "tk2widget", class(w))
	return(w)
}

"tk2progress" <-
function (parent, orientation = c("horizontal", "vertical"), tip = "", ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	orientation <- as.character(orientation[1])
	w <- tkwidget(parent, "ttk::progressbar", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2progress", "tk2widget", class(w))
	return(w)
}

"tk2radiobutton" <-
function (parent, tip = "", ...)
{
	# TODO: associate with a variable and set both states values
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <-tkwidget(parent, "ttk::radiobutton", ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2radiobutton", "tk2widget", class(w))
	return(w)
}

"tk2scale" <-
function (parent, orientation = c("horizontal", "vertical"), tip = "", ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	orientation <- as.character(orientation[1])
	w <- tkwidget(parent, "ttk::scale", orient = orientation, ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2scale", "tk2widget", class(w))
	return(w)
}

"tk2scrollbar" <-
function (parent, orientation = c("horizontal", "vertical"), ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	orientation <- as.character(orientation[1])
	w <- tkwidget(parent, "ttk::scrollbar", orient = orientation, ...)
	class(w) <- c("tk2scrollbar", "tk2widget", class(w))
	return(w)
}

"tk2separator" <-
function (parent, orientation = c("horizontal", "vertical"), ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	orientation <- as.character(orientation[1])
	w <-tkwidget(parent, "ttk::separator", orient = orientation, ...)
	class(w) <- c("tk2separator", "tk2widget", class(w))
	return(w)
}

"tk2spinbox" <-
function (parent, tip = "", ...)
{
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "spinbox", font = "TkDefaultFont",
		relief = "solid", borderwidth = 1, ...)
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2spinbox", "tk2widget", class(w))
	return(w)
}

"tk2table" <-
function (parent, ...)
{
	### TODO: a pure Tcl equivalent
	### TODO: a tile equivalent (some customization, if possible)
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	if (inherits(tclRequire("Tktable", warn = FALSE), "tclObj")) {
		w <- tkwidget(parent, "table", font = "TkDefaultFont", ...)
		class(w) <- c("tk2table", "tk2widget", class(w))
		return(w)
	} else stop("Tcl package 'Tktable' must be installed first")
}

"tk2text" <-
function (parent, tip = "", ...)
{
	### TODO: autohide scrollbars
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	w <- tkwidget(parent, "text", font = "TkTextFont", ...)
	tkconfigure(w, relief = "flat")
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2text", "tk2widget", class(w))
	return(w)
}

"tk2ctext" <-
function (parent, tip = "", ...)
{
	### TODO: autohide scrollbars
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	tclRequire("ctext")
	w <- tkwidget(parent, "ctext", font = "TkFixedFont", ...)
	tkconfigure(w, relief = "flat")
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2ctext", "tk2widget", class(w))
	return(w)
}

### TODO: rework this, using ttk::treeview
"tk2tree" <-
function (parent, tip = "", ...)
{
	### TODO: better icons!
	# Reasonable default icons for files and folders
	if (!is.ttk()) stop("Tcl/Tk >= 8.5 is required")
	images <- as.character(tcl("image", "names"))
	if (!"Tree:dir" %in% images)
		.Tcl("image create photo Tree:dir -data {R0lGODdhEAAQAPIAAAAAAHh4eLi4uPj4APj4+P///wAAAAAAACwAAAAAEAAQAAADPVi63P4wLkKCtTTnUsXwQqBtAfh910UU4ugGAEucpgnLNY3Gop7folwNOBOeiEYQ0acDpp6pGAFArVqthQQAO///}")
	if (!"Tree:file" %in% images)
		.Tcl("image create photo Tree:file -data {R0lGODdhEAAQAPIAAAAAAHh4eLi4uPj4+P///wAAAAAAAAAAACwAAAAAEAAQAAADPkixzPODyADrWE8qC8WN0+BZAmBq1GMOqwigXFXCrGk/cxjjr27fLtout6n9eMIYMTXsFZsogXRKJf6uP0kCADv/}")

	### TODO: correct support of font
	w <- tkwidget(parent, "Tree:create") #, font = "TkDefaultFont", ...)
	tkconfigure(w, relief = "flat")
	if (tip != "") tk2tip(w, tip)
	class(w) <- c("tk2tree", "tk2widget", class(w))
	return(w)
}
