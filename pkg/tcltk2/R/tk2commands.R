# tk2commands.R - Additional tk commands to manipulate tk2 widgets
# Copyright (c), Philippe Grosjean (phgrosjean@sciviews.org)
# Licensed under LGPL 3 or above
#
# Changes:
# - 2007-01-01: fisrt version (for tcltk2_1.0-0)
#
# To do:
# - Rework all this...
# - Style option of Tile widgets?
# - Implement style element options ...

"tk2column" <-
function(widget, action = c("add", "configure", "delete", "names", "cget", "nearest"), ...) {
    Action <- action[1]
    tcl(widget, "column", Action, ...)
}

"tk2list.set" <-
function(widget, items) {
	# Set a list of values for a widget (e.g., combobox)
	if (inherits(widget, "ttk2combobox")) {
        # Tile combobox uses -values parameter
        tkconfigure(widget, values = as.character(items))
    } else {
        # Try to use the defaul method
		# First, clear the list
		tcl(widget, "list", "delete", 0, "end")
		# Then, insert all its elements
		items <- as.character(items)
		for (item in items) tcl(widget, "list", "insert", "end", item)
    }
}

"tk2list.insert" <-
function(widget, index = "end", ...) {
	# Insert one or more items in a list
	if (inherits(widget, "ttk2combobox")) {
        # Tile combobox uses -values parameter
		Items <- as.character(unlist(list(...)))
		if (length(Items) < 1) return()	# Nothing to insert
		List <- as.character(tcl(widget, "cget", "-values"))
		if (length(List) < 2 && List == "") {
			# The list in empty, simply add these items
			List <- Items
		} else if (index == "end" || index > length(List) - 1) {
			List <- c(List, Items)
		} else if (index == 0){
			# Insert items at the beginning of the list
			List <- c(Items, List)
		} else {
			# Insert items inside the list
			List <- c(List[1:index], Items, List[(index + 1):length(List)])
		}
		# Reassign this modified list to the combobox
		tkconfigure(widget, values = List)
	} else {
		tcl(widget, "list", "insert", index, ...)
	}
}

"tk2list.delete" <-
function(widget, first, last = first) {
	# Delete one or more items from a list
	if (inherits(widget, "ttk2combobox")) {
        # Tile combobox uses -values parameter
		List <- as.character(tcl(widget, "cget", "-values"))
		if (length(List) < 2 && List == "") return(List)	# The list in empty
		if (last == "end") last <- length(List) else last <- last + 1
		List <- List[-((first + 1):last)]
		# Reassign this modified list to the combobox
		tkconfigure(widget, values = List)
	} else {
		tcl(widget, "list", "delete", first, last)
	}
}

"tk2list.get" <-
function(widget, first = 0, last = "end") {
	# Get the list of elements in a widget (e.g., combobox)
	if (inherits(widget, "ttk2combobox")) {
        # Tile combobox uses -values parameter
		List <- as.character(tcl(widget, "cget", "-values"))
		if (length(List) < 2 && List == "") return(List)
		if (last == "end") last <- length(List) else last <- last + 1
		return(List[(first +1):last])
	} else {
		as.character(tcl(widget, "list", "get", first, last))
	}
}

"tk2list.size" <-
function(widget) {
	# Get the length of the list of elements in a widget (e.g., combobox)
	if (inherits(widget, "ttk2combobox")) {
        # Tile combobox uses -values parameter
		List <- as.character(tcl(widget, "cget", "-values"))
		return(length(List))
	} else {
		as.numeric(tcl(widget, "list", "size"))
	}
}

"tk2state.set" <-
function(widget, state = c("normal", "disabled", "readonly")) {
	# Change the state of a widget
	state <- as.character(state[1])
	# Treatment is different, depending if the widget is a tile widget, or not
	if (substring(class(widget)[1], 1, 3) == "ttk") {
		# This is a tile widget
		tkconfigure(widget, state = state)
	} else {
		# This is a plain Tk widget
		if (state == "readonly") {
			.Tcl(paste("catch {", widget$ID, " configure -editable false}",  sep = ""))
			.Tcl(paste("catch {", widget$ID, " configure -state readonly}",  sep = ""))
		} else {
			.Tcl(paste("catch {", widget$ID, " configure -editable true}",  sep = ""))
			tkconfigure(widget, state = state)
		}
	}
}

"tk2insert.multi" <-
function(widget, where = "end", items) {
    # We insert one or several lines in a multicolumn widget
    items <- as.matrix(items)
    # A vector is coerced into a column matrix and we want a row matrix here
    if (ncol(items) == 1) items <- t(items)
    # Convert the matrix into [list {el1} {el2} {el3}] [list {el4}, {el5}, {el6}], ...
    makeTclList <- function(x) paste("[list {", paste(x, collapse = "} {"), "}]", sep = "")
    TclList <- paste(apply(items, 1, makeTclList), collapse = "\\\n")
    .Tcl(paste(widget, "insert", where, TclList))
}

"tk2notetraverse" <- function(nb) {
	# This function is only useful with tile widget
	if (!is.tile()) return(FALSE)
	tcl("ttk::notebook::enableTraversal", nb)
	return(TRUE)
}

"tk2notetab" <-
function(nb, tab) {
    # Different treatment, depending if it is tile or nor
    if (inherits(nb, "ttk2notebook")) {
        # Tile notebook
        # We need the tab index, so, look for it
		ntab <- as.numeric(tcl(nb, "index", "end"))
		if (ntab < 1) return(NULL)
		tabidx <- -1
		for (i in 0:(ntab - 1))
			if (tclvalue(tcl(nb, "tab", i, "-text")) == tab) {
				tabidx <- i
				break
			}
		if (tabidx > -1) {
			tabid <- paste(nb$ID, tabidx + 1, sep = ".")
			# Create a simili tkwin object referring to this page
            w <- list()
            w$ID <- tabid
			w$env <- new.env()
			w$env$num.subwin <- 0
			w$env$parent <- nb
            class(w) <- c("ttk2notetab", "tk2container", "tkwin")
            return(w)
		} else return(NULL) # Tab not found!
    } else if (inherits(nb, "tk2notebook")) {
        # Plain Tk notebook
		tab <- tclvalue(.Tcl(paste("Notebook:frame", nb$ID,
			paste("{", tab, "}", sep = ""))))
		if (tab == "") {
            # This page does not exist!
            return(NULL)
        } else {
            # Create a simili tkwin object referring to this page
            w <- list()
            w$ID <- tab
			w$env <- new.env()
			w$env$num.subwin <- 0
			w$env$parent <- nb
            class(w) <- c("tk2notetab", "tk2container", "tkwin")
            return(w)
        }
    } else stop ("'nb' must be either a 'tk2notebook', or a 'ttk2notebook'")
}

"tk2notetab.select" <-
function(nb, tab) {
    # Select a tab in a notebook, different depending if it is tile or not
    if (inherits(nb, "ttk2notebook")) {
        # Tile notebook
		# We need the tab index, so, look for it
		ntab <- as.numeric(tcl(nb, "index", "end"))
		if (ntab < 1) return(invisible(FALSE))
		tabidx <- -1
		for (i in 0:(ntab - 1))
			if (tclvalue(tcl(nb, "tab", i, "-text")) == tab) {
				tabidx <- i
				break
			}
		if (tabidx > -1) {
			tkselect(nb, tabidx)
			return(invisible(TRUE))
		} else return(invisible(FALSE))
    } else if (inherits(nb, "tk2notebook")) {
        ### TODO: would also like to raise a given page number!
        # Plain Tk notebook
        .Tcl(paste("Notebook:raise ", nb$ID, " {", tab[1], "}", sep = ""))
		return(invisible(tk2notetab.text(nb) == tab))
    } else stop ("'nb' must be either a 'tk2notebook', or a 'ttk2notebook'")
}

"tk2notetab.text" <-
function(nb) {
    # Select a tab in a notebook, different depending if it is tile or not
    if (inherits(nb, "ttk2notebook")) {
        # Tile notebook
		return(tclvalue(tcl(nb, "tab", "current", "-text")))
    } else if (inherits(nb, "tk2notebook")) {
        # Plain Tk notebook
        return(tclvalue(.Tcl(paste("Notebook:current", nb$ID))))
    } else stop ("'nb' must be either a 'tk2notebook', or a 'ttk2notebook'")
}

# Themes management
"tk2theme.elements" <- function() {
	if (!is.tile()) return(NULL)
	return(as.character(.Tcl("ttk::style element names")))
}

"tk2theme.list" <- function() {
	if (!is.tile()) return(NULL)
	return(as.character(.Tcl("ttk::style theme names")))
}

"tk2theme" <- function(theme = NULL) {
	if (!is.tile()) return(NULL)
    if (is.null(theme)) { # Get it
        res <- getOption("tk2theme")
    } else { # Set it to theme
        .Tcl(paste("ttk::style theme use", theme)) # Better to use tile::setTheme?
        # And save current theme in option "tk2theme"
        options(tk2theme = theme)
        res <- theme
    }
    return(res)
}

"setLanguage" <- function(lang) {
	# Change locale for both R and Tcl/Tk
	Sys.setenv(language = lang)
	try(Sys.setlocale("LC_MESSAGES", lang), silent = TRUE)	# Fails on Windows!
	res <- tclRequire("msgcat")
	if (inherits(res, "tclObj")) {
		tcl("::msgcat::mclocale", lang)
		return(TRUE)
	} else {
		return(FALSE)
	}
}

"getLanguage" <- function() {
	# Try to recover current language used for messages and GUI stuff in R
	lang <- Sys.getenv("language")
	if (lang == "") lang <- Sys.getlocale("LC_MESSAGES")
	# This is a bad hack that probably does not work all the time, but at least,
	# it works under Windows for getting "fr" for French language
	if (lang == "") lang <- tolower(substr(Sys.getlocale("LC_TIME"), 1, 2))
	return(lang)
}

"is.tk" <-
function() {
	return(tclvalue(.Tcl("catch { package present Tk }")) == 0)
}

"is.tile" <-
function() {
	# Tile, alias ttk widgets are automatically installed under Tk >= 8.5
	if (as.numeric(.Tcl("set tcl_version")) >= 8.5) return(TRUE)
	# Determine if tile is loaded, and if we want to use it
	use.tile <- getOption("tcltk2.tile")
	if (!is.null(use.tile) && !use.tile) return(FALSE)
	# Otherwise, look if the tile package is loaded
	return(tclvalue(.Tcl("catch { package present tile }")) == 0)
}

"tile.load" <-
function(warn = TRUE) {
	if (!is.tk()) return(FALSE) # Impossible to load tile if tk is not loaded
	if (is.tile()) return(TRUE)	# Already loaded

	# We must take care of fonts synchronisation and other stuff like
	# options(tcltk2.tile)

	# First delete all Tk* fonts created in Tcl/Tk (otherwise, loading of tile fails?!)
	tkfonts <- as.character(tkfont.names())
	tkfonts <-  tkfonts[grep("^Tk", tkfonts)]
	for (font in tkfonts) tkfont.delete(font)

	# Try loading tile
	if (inherits(tclRequire("tile", warn = warn), "tclObj")) {	# OK
		# Finalize fonts
		tk2font.setstyle(system = TRUE, default.styles = TRUE, text = TRUE)
		# Indicate that tile is loaded
		options(tcltk2.tile = TRUE)
		return(TRUE)
	} else { # Impossible to load tile (not installed on this machine?
		# We must restore Tk fonts
		# Look for a place to find it
		libs <- .libPaths()
		for (lib in libs) {
			fontfile <- file.path(lib, "tcltk2", "tklibs", "fonts.tcl")
			if (file.exists(fontfile)) {
				tcl("source", fontfile)
				break
			}
		}
		# Finalize fonts
		tk2font.setstyle(system = TRUE, default.styles = TRUE, text = TRUE)
		options(tcltk2.tile = FALSE)
		return(FALSE)
	}
}

"tile.use" <-
function(use.it = TRUE) {
	options(tcltk2.tile = use.it)
	# Indicate also for Tcl code what we want
	if (use.it) .Tcl("set tile_use 1") else .Tcl("set tile_use 0")
}
