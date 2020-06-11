# tcltk2 To Do list

- Despite I changed `::msgcat::mclocale` to `de`, `tk2chooseFont()` is still in English (but it works for `fr`... why?)

- Rework `tk2edit()` [takes numeric only and return characters for the moment!] Rework also the button bar.

- Add toolbar, datefield, etc. 

- For the tips: select background color and font from style (same for bwidgets)

- Tcl/Tk features to add:

    info/winfo
    update Idle tasks (update idletasks)
    bgerror
    correct handling of catch result => procedure for that error to generate tcl errors
    exit to end the application?
    memory
    package
    pkg_mkIndex
    puts: write code from Tcl to the R console
    functions to manipulate Macintosh resources
    tclvars

- A function to display the Tcl/Tk help and additional package help from R

- Easier definition and retrieving of bindings (+ keysyms) and events

- Bitmap (2 colors) and image (+ IMG package? PPM/PGM and GIF by default)

- Cursors

- Experiment with focus -force! + lower/raise

- Make a demo section
