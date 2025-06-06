# tcltk2 1.6.1

- LICENSE file changed into LICENSE.note, as suggested by CRAN.

# tcltk2 1.6.0

- `setLanguage()` now correctly defines the language for translated messages in R, as it does for Tcl/Tk. It uses the `Sys.setLanguage()` base function that was first defined R 4.2.0. Consequently, this version of tcltk2 has a dependency to R >= 4.2.0 now.

- Various changes and Tcl/Tk package update to make tcltk2 compatible with Tcl/Tk 9.0. Among the Tcl/Tk packages upgrade: cursor 0.1 -> 0.3.1, history 0.1 -> 0.3, ntext 1.0b3 -> 1.0, snit 1.0 -> 2.3.4, struct (only matrix and list structs) 2.1 -> 2.2, tablelist 6.9 -> 7.6, tooltip 1.4.5 -> 2.0.1 and widget 3.1 -> 3.2. The following tcl files were also adapted to be compatible with Tcl/Tk: choosefont.tcl, keramik.tcl zand plastik.tcl. New tcl packages needed by struct 2.2 are added: cmdline1.5.3 and textutil 0.10.

- More generics and methods for **tk2widget** objects are exported: `config`, `config <-`, `selection`, `selection<-`, `size`, and `visibleItem`.

# tcltk2 1.5.2

- A bug in `setLanguage()` caused a crash on Windows. Fixed.

- On Unix/Linux/Mac system, an error was generated when the package loads due to the inaccessibility of the `tk_library`. This is now fixed (in this case, it is simply not loaded).

# tcltk2 1.5.1

- More robust code for `addTclPath()`, thank to GegznaV.

# tcltk2 1.5.0

- Documentation reworked using Roxygen2 and pkgdown.

- ctext upgraded from 3.2 to 3.3.

- cursor upgraded from 0.2 to 0.3.1.

- datefield upgraded form 0.2 to 0.3.

- ico is upgraded from 1.0 to 1.1.

- ntext is upgraded from 0.81 to 1.0b3.

- widget is upgraded from 3.0 to 3.1.

# tcltk2 1.4.0

- tablelist Tk widget updated from v5.5 to v6.9.

- `struct::list` and `struct::matrix` (version 2.1) are added. These are Tcl functions to deal with lists and 2d-tables a.k.a. matrices.

# tcltk2 1.3.0

- Message translation is completed. `setLanguage()`/`getLanguage()` work now in a more robust way. `getLanguage()` separately reports the language used by R and by Tcl/Tk, and translation catalogs for Tcl and Tk are automatically loaded when the **tcltk2** package is loaded. The new functions `tclmclocale()`, `tclmc()` and `tclmcset()` complete the functions available to manage message translation in Tcl from within R.

- A dialog box to enter uncode characters in tk2entry or tk2text widgets and to configure a composer to enter such unicode character on the keyboard are added (functions `tk2unicode_xxx()`).

- All old 'ttk2xxx' widget classes are now converted into 'tk2xxx' classes.

# tcltk2 1.2-12

- A bug led to incorrect `tk2list.set()`, `tk2list.insert()` and `tk2list.delete()` treatment in case of tk2combobox widgets. Corrected.

# tcltk2 1.2-11

- After a problem for active menu items not displayed in a contrasted color on some platforms, `tk2menu()` function receives two new arguments: `activebackground=` and `activeforeground=`, but reasonable colors are used in case these are not provided, with a fallback to white on darkblue in case it is not possible to determine the color used for the current theme. That color is *not* changed with the theme for existing menu items (but it is for future menu items). This is due to the fact that Tk menus do not follow the ttk styling scheme.

# tcltk2 1.2-10

- Reworked Author field in the DESCRIPTION file.

- A bug in `tk2listbox()` and several other `tk2Xxx()` widgets when it is not possible to get fieldbackground color for the TEntry widget is corrected (thanks Jaime Egido).

# tcltk2 1.2-9

- New theme handling introduced in version 1.2-8 resulted in an invisible caret in text widget.

- Further tweaking of color themes: now `fieldbackground` for entry, combobox, canvas, listbox, mclistbox, tablelist, spinbox, text and ctext widgets (build using old Tk widgets or megawidgets) defaults to the correct theme color.

# tcltk2 1.2-8

- A better handling of fonts and colors for Tk widgets according to themes used for Ttk widgets using `tk2theme()`. Also for menus.

- The default font was not reset properly after switching back from `radiance` to another theme.

# tcltk2 1.2-7

- A `tk2tablelist()` function is added to create a tablelist widget (the Tcl package was distributed with tcltk2, but no convenient widget creator provided). A very simple example is also added in the document. The widget is very rich, and you will have to figure out by yourself how to access all its command from its original documentation.

- A `tk2swaplist()` dialog box is added.

# tcltk2 1.2-6

- No additional ttk themes are loaded on startup any more. The required resources are now loaded on demand in the `tk2theme()` function [suggested by Milan Bouchet-Valat & John Fox]. Note that the additional themes `plastik`, `keramik`, `keramik_alt`, `clearlooks` and `radiance` are not listed any more with `tk2theme.list()`, unless their resources are loaded using, e.g., `tk2theme("plastik")`. Note also that the `radiance` theme permanently changes fonts used by the Ttk widgets to fonts identical, or close to those used by Ubuntu.

- `tk2theme()` now tries to set the same background color for old tk widgets than the color used by ttk widgets. Suggested by Milan Bouchet-Valat.

# tcltk2 1.2-5

- Clarifications of license terms for R code and additional Tcl libraries.

# tcltk2 1.2-4

- Temporary objects are now located in `SciViews:TempEnv` instead of `TempEnv`.

# tcltk2 1.2-3

- The Tk configuration sequence in `.onLoad()` is changed.

# tcltk2 1.2-2

- For some reasons, version 1.2-1 on CRAN looks like version 1.2-0 on R-Forge. This version is an update.

- `tk2ico.XXX()` function change (incompatible changes for some of them!) due to drop of `winico.dll` in favor of the full-Tcl 'ico' package. See `?tk2ico.set`.

# tcltk2 1.2-1

- The new ttk theme introduced in 1.2-0 have introduced a bug preventing the **tcltk2** package to load on Windows OS when 'cat' program is not available (this bug was not catch by the test machines which had Rtools, and thus, 'cat', installed). This bug appeared in the internal `.isUbuntu()` function. Fixed.

- A couple of warnings for partial argument matching in `tclTaskXXX()` functions under R 2.15.0 are corrected.

- Documentation and demos for the tablelist Tk widgets are not distributed any more in the tcltk2 package, to keep its size compatible with CRAN requirements (no more than 5Mb). Those are available from http://www.nemethi.de/.

# tcltk2 1.2-0

- `Clearlooks` ttk theme added and made default theme under Linux. More modern look&feel for ttk widgets under Linux!

- `Radiance` ttk theme created and added. This matches ambiance and radiance themes under Ubuntu 11.x. This is the default theme used in Ubuntu.

- The tk widget tablelist is updated to version 5.5.

- `tk2listbox()` is completelly reworked to provide (autohide) scrollbars, integration with the `tk2theme()` and easier filling of its content.

- `tk2label()` is now fully implemented.

- Many methods for 'tk2widget' and 'tk2cfglist' objects are now provided.

- `tk2style()`, `tk2dataList()` and `tk2configList()` provide info on style, config and data associated with a 'tk2widget'.

# tcltk2 1.1-6

- When setting `options(scipen = -5)` or lower, `is.tk()` returned `FALSE`, even if Tk package was installed. Corrected.

# tcltk2 1.1-5

- Little correction in `Winico.c` that prevented it to compile correctly on all Windows architectures (thanks Prof. B. Ripley for the patch).

# tcltk2 1.1-4

- `Winico.c` modified to compile on Windows 64-bit (but still not OK?).

- Added ttk themes `plastik`, `keramik` and `keramik_alt`. Ttk theme `plastik` is now used by default on other platforms than Windows.

# tcltk2 1.1-3

- New `/win/src/Makevars` to make it compatible with the double compilation for Windows 32bit and 64bit. Thanks Prof. Brian Ripley.

- Correction of the example in `?tk2reg`. Thanks Tony Plate.

- `.onload()` now works inside SciViews.

# tcltk2 1.1-2

- Patch to `.onload()` and to source code of `Winico0.6.c` submitted by Prof. Brian Ripley to make tcltk2 working on 64-bit Windows. Thanks.

# tcltk2 1.1-1

- A bug in `tk2mclistbox()`, claiming for missing `-state` argument when selecting an item in the box is corrected, thanks to a patch provided by Christiane Raemsch (and slightly modified).

# tcltk2 1.1-0

- Several Tcl packages are added, or upgraded:

    autoscroll 1.1 (added)
    ctext 3.2 (upgraded from 3.1)
    cursor 0.2 (upgraded from 0.1)
    datefiled 0.2 (added)
    Diagrams 0.2 (added)
    getstring 0.1 (added)
    history 0.1 (added)
    ico 0.1 (added, in partial replacement of Winico 0.6 )
    ipentry 0.3 (added)
    khim 1.0 (added)
    ntext 0.81 (added)
    snit 1.0 (added, and required by widget)
    swaplist 0.2 (added)
    tablelist 4.10 (added)
    tooltip 1.4 (added and in replacement of the buggy balloon 1.2)
    widget 3.0 (added)

- There are new `tclAfterXxx()` and `tclTaskXxx()` functions to schedule tasks to be executed later in R (using the Tcl `after` function).

# tcltk2 1.0-9

- tile and Tktable Tcl packages are eliminated. **tcltk2** now uses ttk widgets that come with Tk 8.5. You are supposed to install Tktable yourself (optional) if you need it. Note that recent R (version >= 2.9.0) install both Tcl/Tk 8.5 and Tktable 2.9 under Windows and Mac OS X. So, those two Tcl packages should be available without extra work on these OSes.

- The little Windows utility `execdde.exe` is no longer distributed with the **tcltk2** package. It is available from http://www.sciviews.org/SciViews-R.

- With Tcl/Tk 8.5, system fonts are now correctly initialized. Thus, `winSystemFonts()` is not needed any more, and it is deleted from the package (it was only used internally at package loading).

- The Tcl/Tk package 'Winico' is now provided in source form and its DLL is compiled (Windows only).

# tcltk2 1.0-8

- Most windows executables were removed. The rest is in `/win` and a `configure.win` / cleanup mechanism is used to install them under Windows only.

- `BinaryFiles` is added to declare these binaries.

- An error preventing system fonts to load in `tk2fonts()` is corrected (thanks to B. Ripley).

- When the package was installed on a path with spaces, the `SystemFonts.exe` program was not executed properly under Windows. Quoting the command for `system()` solved the problem (thanks to Pascal Hirsh).

- Tile version of paned widget is disabled because it does not work any more with R 2.9.0 - Tcl/Tk 8.5.

# tcltk2 1.0-7

- Detection of system fonts used under Windows.

# tcltk2 1.0-6

- Complete rewrite of the package using tile and a larger series of additional tk widgets.

# tcltk2 0.9-5

- First version distributed on CRAN.
