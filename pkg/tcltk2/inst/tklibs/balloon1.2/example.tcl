#!/usr/bin/wish

source "./balloon.tcl"

option add *highlightThickness 0 

label .head -text "move the pointer\nhere" -relief groove
label .suite -text "another balloon here" -relief groove

button .bye -text "Quit" -command exit

pack .head -side top -fill x -pady 10 -padx 10
pack .suite .bye -side right -pady 10 -padx 10
pack .bye -side bottom -pady 10 -padx 10

set_balloon .head "first balloon"
set_balloon .suite "second balloon"
