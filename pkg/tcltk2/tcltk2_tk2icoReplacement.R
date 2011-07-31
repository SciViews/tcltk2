## Replacement for tk2ico in tcltk2 package
## to avoid all the nightmare of compiling C Tcl package code!
## I need to drop the taskbar feature and just keep the
## possibility to change Tk windows icons


## Here is how one defines the default icon out of one exe (under Windows)
tkwm.iconbitmap(tt, default = file.path(R.home("bin"), "Rgui.exe"))

## Here is how one define an icon for a given Tk window
tkwm.iconbitmap(tt, file.path(R.home("bin"), "Rgui.exe"))

## One can also use an .ico file under Windows
tkwm.iconbitmap(tt2, system.file("gui", "SciViews.ico", package = "tcltk2"))

## Under Linux, it is a xbm file and filename must start with '@'
## TODO...

## Here is how to use a loaded bitmap ressource
## TODO...