#!/usr/bin/wish

### TODO: allow to use tile automatically
#         menu with statusbar tips
#         hide status.info and display other widgets + size grip
#         show it only when text is not empty
#         allow also for vertical or horizontal sash and toolbar docks around
#         customize tooltip font and color to current system specs

# substitute your favorite method here...
source toolbar.tcl
package require toolbar 1.0

# To test with tile
package require tile 0.7.2

# Internationalization
package require msgcat
::msgcat::mclocale en

# Generate icons (see also: iconlib.tcl):
source iconlib.tcl
foreach {icon data} [array get ::ImgData]  {
  set ::ICON($icon) [image create photo -data $data]
}


#text .t
#grid .t

#if {[catch { package present tile }]} {
#  button .b -text "  Choose font  " -font TkDefaultFont
#} else {
#	ttk::button .b -text "Choose font"
#}
#.b configure -command {
#  set font [choosefont [font actual fontChooser]]
#  if {$font != "" } { 
#    catch { font delete fontChooser }
#    eval [linsert $font 0 font create fontChooser]
#  }
#}
#grid .l .b -padx 5 -pady 5

## Test our Toolbar package. Comment out for common use...


image create photo timage -data \
{R0lGODlhEAAQAKUAAGRjZGJmZ1FQUYSChICFh2KdnyO6u1FlZ4GEhmGeoCO5
ugChogCChFFfYWGhoiK6uwCgoXw1NgDKy+RZWvcICKRfYQC8vepERf8AAPkG
BopiY8VERcUAANYAALQZGYR6fB16fABsbrAYGAO5um9xcgBUVUxCQwBiZABv
cElISWxrbHd1d0xKTIiGiAB2eBRaW01PUQB5exBVV2FwcQC5uglOT2FtbmJr
bf///////////////////////////////yH+Dk1hZGUgd2l0aCBHSU1QACH5
BAEKADgALAAAAAAQABAAAAZxQJxwCCgaAYGhUjBoNgkFw0EpZDYRCcWC0aDi
rI4HhEHuUiNNCXltHk4olYFlXR5eMPiMZk5vbzgdGB4fFiAhbF4iHwMjJCWI
VCZNFicokEopKit8l0MsOC2cdV5CnC4vMKSlDDEyM6pDNDU2sEo3pEEAOw==}


## Create a status bar...
frame .status -relief groove -bd 1
pack .status -fill x -side bottom -padx 0 -pady 0

label .status.info -text {This is a status bar...} -anchor w; # -relief solid -bd 1
pack .status.info -fill both -expand 1

## Add other widgets to the statusbar + show them and hide .status.info if its text
# is {}, and invert selection otherwise

## Create a frame for holding the rest
frame .clientarea
pack .clientarea -fill both -expand 1 -side top -padx 0 -pady 0

## Create toolbar frames on all four sides...
set TF [::toolbar::ToolbarFrame .clientarea.toolbarFrame1]
pack $TF -side top -fill x

set TF2 [::toolbar::ToolbarFrame .clientarea.toolbarFrame2]
pack $TF2 -side bottom -fill x

set VTF [::toolbar::ToolbarFrame .clientarea.vtoolbarFrame1 -orientation vertical]
pack $VTF -side left -fill y

set VTF2 [::toolbar::ToolbarFrame .clientarea.vtoolbarFrame2 -orientation vertical]
pack $VTF2 -side right -fill y

# And this is the real area where we can put the rest...
frame .clientarea.area1 -relief groove -borderwidth 1
pack .clientarea.area1 -fill both -expand 1


## 2) Create a toolbar in this toolbar frame...
set tb1 [::toolbar::create $TF.tb1]
## 3) Add some buttons/widgets in this toolbar...
#::toolbar::addwidget $tb1 label -text {T 1} -bd 0 -bg red -fg white \
#  -tooltip {T 1} -statuswidget .status.info
  
#::toolbar::addwidget $tb1 ttk::label -text {T 1} \
#  -tooltip {T 1} -statuswidget .status.info
::toolbar::addbutton $tb1 -image $::ICON(bold) -statuswidget .status.info \
  -tooltip {Button 1} -command {Command {Button 1}}
::toolbar::addbutton $tb1 -image timage -statuswidget .status.info \
  -tooltip {Button 2} -command {Command {Button 2}}
::toolbar::addbutton $tb1 -image timage -statuswidget .status.info \
  -tooltip {Button 3} -command {Command {Button 3}}
::toolbar::addseparator $tb1
::toolbar::addwidget $tb1 label -text {Exit :} -bd 0 -tooltip Exit... \
  -statuswidget .status.info
::toolbar::addbutton $tb1 -image timage  \
  -tooltip {Exit} -command {exit} -statuswidget .status.info
## 4) Pack the toolbar inside the toolbar frame...
pack $tb1 -side left -fill y

## Create a second toolbar in this toolbar frame...
set tb2 [::toolbar::create $TF.tb2]
## 3) Add some buttons/widgets in this toolbar...
::toolbar::addwidget $tb2 label -text {T 3} -bd 0 -bg orange -fg white \
  -tooltip {T 3} -statuswidget .status.info
::toolbar::addwidget $tb2 label -text {Type Here:} -bd 0 \
  -tooltip {The next is an entry widget. You can type there...} \
  -statuswidget .status.info
::toolbar::addwidget $tb2 entry -width 5 -relief sunken -bg white -fg navy\
  -tooltip {This is an entry widget. You can type here...} \
  -statuswidget .status.info
::toolbar::addwidget $tb2 spinbox -width 2 -relief sunken -bg white \
  -fg navy -tooltip {This is a spinbox widget!} -from 0 -to 20 \
  -statuswidget .status.info
set mb [::toolbar::addwidget $tb2 menubutton -text {File} -indicatoron 0 \
  -tooltip {This is a menubutton widget!} -statuswidget .status.info]
menu $mb.menu -tearoff 0
$mb.menu add command -label Exit -command exit
$mb configure -menu $mb.menu
::toolbar::addwidget $tb2 checkbutton -text Select \
  -tooltip {This is a checkbutton widget. You can select it...} \
  -statuswidget .status.info
## Pack the toolbar inside the toolbar frame...
pack $tb2 -side left -fill y
## 5) Pack the toolbar frame in our window...


## Create a toolbar in this toolbar frame...
set tbv1 [::toolbar::create $VTF.tbv1]
## Add some buttons/widgets in this toolbar...
::toolbar::addwidget $tbv1 label -text {T 2} -bd 0 -bg blue -fg white \
  -tooltip {T 2} -statuswidget .status.info
::toolbar::addbutton $tbv1 -image timage -statuswidget .status.info \
  -tooltip {Button 1} -command {Command {Button 1}}
::toolbar::addbutton $tbv1 -image timage -statuswidget .status.info \
  -tooltip {Button 2} -command {Command {Button 2}}
::toolbar::addbutton $tbv1 -image timage -statuswidget .status.info \
  -tooltip {Button 3} -command {Command {Button 3}}
::toolbar::addseparator $tbv1
::toolbar::addwidget $tbv1 entry -width 5 -relief sunken \
  -bg white -fg navy -tooltip {You can type in here!} \
  -statuswidget .status.info
::toolbar::addseparator $tbv1
::toolbar::addwidget $tbv1 label -text {Exit :} -bd 0 -tooltip Exit... \
  -statuswidget .status.info
::toolbar::addbutton $tbv1 -image timage  \
  -tooltip {Exit} -command {exit} -statuswidget .status.info
## Pack the toolbar inside the toolbar frame...
pack $tbv1 -side left -fill y


## Add an area with some buttons that do various ops over the toolbars...
text .clientarea.area1.text -bd 0
pack .clientarea.area1.text -fill both -expand 1

#button .area1.act1  -text {Activate 1} -bg red -fg white -command \
#  "::toolbar::activate $tb1"
#button .area1.dact1 -text {Deactivate 1} -bg red -fg white -command \
#  "::toolbar::deactivate $tb1"
#button .area1.act2  -text {Activate 2} -bg blue -fg white -command \
#  "::toolbar::activate $tbv1"
#button .area1.dact2 -text {Deactivate 2} -bg blue -fg white -command \
#  "::toolbar::deactivate $tbv1"
#button .area1.act3  -text {Activate 3} -bg orange -fg white -command \
#  "::toolbar::activate $tb2"
#button .area1.dact3 -text {Deactivate 3} -bg orange -fg white -command \
#  "::toolbar::deactivate $tb2"
#grid .area1.act1 .area1.dact1 .area1.act2 .area1.dact2 .area1.act3 .area1.dact3 \
#  -padx 2 -pady 2 -sticky snew
#button .area1.shw1  -text {Show 1} -bg red -fg white -command \
#  "::toolbar::deiconify $tb1"
#button .area1.hide1 -text {Hide 1} -bg red -fg white -command \
#  "::toolbar::HandleCallback $tb1 -2"
#button .area1.shw2  -text {Show 2} -bg blue -fg white -command \
#  "::toolbar::deiconify $tbv1"
#button .area1.hide2 -text {Hide 2} -bg blue -fg white -command \
#  "::toolbar::HandleCallback $tbv1 -2"
#button .area1.shw3  -text {Show 3} -bg orange -fg white -command \
#  "::toolbar::deiconify $tb2"
#button .area1.hide3 -text {Hide 3} -bg orange -fg white -command \
#  "::toolbar::HandleCallback $tb2 -2"
#grid .area1.shw1 .area1.hide1 .area1.shw2 .area1.hide2 .area1.shw3 .area1.hide3 \
#  -padx 2 -pady 2 -sticky snew
#button .area1.flt1  -text {Float 1} -bg red -fg white -command \
#  "::toolbar::HandleCallback $tb1 -1"
#button .area1.mnt1 -text {Mount 1} -bg red -fg white -command \
#  "catch \"destroy $tb1.fltWin\""
#button .area1.flt2  -text {Float 2} -bg blue -fg white -command \
#  "::toolbar::HandleCallback $tbv1 -1"
#button .area1.mnt2 -text {Mount 2} -bg blue -fg white -command \
#  "catch \"destroy $tbv1.fltWin\""
#button .area1.flt3  -text {Float 3} -bg orange -fg white -command \
#  "::toolbar::HandleCallback $tb2 -1"
#button .area1.mnt3 -text {Mount 3} -bg orange -fg white -command \
#  "catch \"destroy $tb2.fltWin\""
#grid .area1.flt1 .area1.mnt1 .area1.flt2 .area1.mnt2 .area1.flt3 .area1.mnt3 \
#  -padx 2 -pady 2 -sticky snew
#button .clientarea.area1.print -text {Print Variables} -command \
#  {catch {console show};puts \n\n###########################\n
#  parray ::toolbar::ToolbarSpecifications}
#grid .clientarea.area1.print -columnspan 6 -padx 2 -pady 2 -sticky snew

  
proc Command {message} {
  tk_messageBox -icon info -title Info: -type ok -message $message
}

wm geometry . 800x400
focus .
