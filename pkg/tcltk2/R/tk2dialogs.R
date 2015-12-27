### tk2dialogs.R - Support for additional Tk dialogs
### Copyright (c), Philippe Grosjean (phgrosjean@sciviews.org)
### Licensed under LGPL 3 or above
###
### Changes:
### - 2007-02-07: fisrt version (for tcltk2_1.0-2)
###
### To do:
### - A good dialog box for choosing R colors (by number, name or RGB value)

tk2chooseFont <- function (...)
{
	if (!is.tk()) stop("Package Tk is required but not loaded")
	tclRequire("choosefont")
	# Make sure message translations are correctly loaded
	try(tcl("mcload", system.file("tklibs", "choosefile", "msgs",
		package = "tcltk2")), silent = TRUE)
	tcl("choosefont::choosefont", ...)
}

## Unicode character input
.tk2unicode_file <- function (app = getOption("tk2app", "R"))
	file.path("~", paste0(".khimrc.", as.character(app)[1]))

.tk2unicode_load <- function ()
{
	## Try to get current configuration
	cfg <- try(tcl("::khim::getConfig"), silent = TRUE)
	if (inherits(cfg, "try-error")) {
		## Try loading the khim package
		res <- tclRequire("khim")
		if (!inherits(res, "tclObj")) return()
		## If a config file exists, load it now
		cfgfile <- .tk2unicode_file()
		if (file.exists(cfgfile))
			tcl("source", cfgfile)
		## finally get the updated config
		cfg <- tcl("::khim::getConfig")
	}
	# Make sure message translations are correctly loaded
	try(tcl("mcload", system.file("tklibs", "khim", "msgs",
		package = "tcltk2")), silent = TRUE)
	tclvalue(cfg)
}

tk2unicode_config <- function (parent)
{
	if (!inherits(parent, "tkwin"))
		stop("'parent' must be a 'tkwin' object")
	
	## Make sure khim is loaded and get its current config
	cfg <- .tk2unicode_load()
	
	## Display the configuration dialog box
	.Tcl(paste0("::khim::getOptions ", parent$ID, ".khim"))
	
	## Get the new config and compare it with the old one
	cfg2 <- tclvalue(tcl("::khim::getConfig"))
	if (cfg2 != cfg) {
		## Ask to save the new config
		msg <- tclmc("Do you want to save this configuration on disk?",
			domain = "khim")
		res <- tkmessageBox(
			message = msg, icon = "question", type = "yesno")
		if (tclvalue(res) == "yes") {
			cfgfile <- .tk2unicode_file()
			cat(cfg2, file = cfgfile)
		}
	}	
}

tk2unicode_select <- function (widget)
{
	.tk2unicode_load()
	tcl("::khim::FocusAndInsertSymbol", widget$ID)
}
	
tk2unicode_bind <- function (widget)
{
	if (!inherits(widget, c("tk2text", "tk2entry")))
		stop("You can bind the unicode composer to tk2text() or tk2entry() widgets only")
	## Make sure evertything is loaded and configured correctly
	.tk2unicode_load()
	## Create the binding
	if (inherits(widget, "tk2text")) {
		tkbindtags(widget, paste0(widget$ID , " KHIM Text ",
			widget$env$parent$ID, " all"))
	} else { # This must be a tk2entry widget
		tkbindtags(widget, paste0(widget$ID , " KHIM Entry ",
			widget$env$parent$ID, " all"))
	}	
}
