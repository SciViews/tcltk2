# package ctext
# By George Peter Staplin
# enhanced by Andreas Sievers
package provide CText [lindex {Revision: 3.0 } 1]

package require Tk

namespace eval ctext {
    variable highlightOn
    set hightlightOn 1
}

proc ctext {win args} { 
	if {[expr {[llength $args] & 1}] != 0} {
		return -code error "Invalid number of arguments given to ctext (uneven number): $args"
	}
	# tk_messageBox -message $args
	frame $win -class Ctext

	text .__ctextTemp
	set cmdArgs(-fg) [.__ctextTemp cget -foreground]
	set cmdArgs(-bg) [.__ctextTemp cget -background]
	set cmdArgs(-font) [.__ctextTemp cget -font]
	set cmdArgs(-relief) [.__ctextTemp cget -relief]
	destroy .__ctextTemp
    set cmdArgs(-yscrollcommand) ""
	set cmdArgs(-linemap) 1
	set cmdArgs(-linemapfg) $cmdArgs(-fg)
	set cmdArgs(-linemapbg) $cmdArgs(-bg)
	
	array set cmdArgs $args
	
	foreach flag {foreground background} short {fg bg} {
		if {[info exists cmdArgs(-$flag)] == 1} {
			set cmdArgs(-$short) $cmdArgs(-$flag)
			unset cmdArgs(-$flag)
		}
	}
	
	#Now remove flags that will confuse text and those that need modification:
	foreach arg {yscrollcommand linemap linemapfg linemapbg} {
		set loc [lsearch $args -$arg]
		if {$loc != -1} {
			set firstArgs [lrange $args 0 [expr {$loc - 1}]]
			set endArgs [lrange $args [expr {$loc + 2}] end]
			set args "$firstArgs $endArgs"
		}
	}

    
    text $win.l -font $cmdArgs(-font) -width 1 -height 1 \
		-relief $cmdArgs(-relief) -bg $cmdArgs(-bg)  -fg $cmdArgs(-fg)

	$win.l config -fg $cmdArgs(-linemapfg) -bg $cmdArgs(-linemapbg)

	set topWin [winfo toplevel $win]
	bindtags $win.l "$win.l $topWin all"

	if {$cmdArgs(-linemap) == 1} {
		pack $win.l -side left -fill y
	}
	
    append args " "
    # tk_messageBox -message $cmdArgs(-yscrollcommand)
    append args [list -yscrollcommand [list ctext::event:yscroll $win $cmdArgs(-yscrollcommand)]]
	pack [eval text $win.t $args] -side right -fill both -expand 1
    $win.t tag configure elide -elide 1
    $win.l tag configure elide -elide 1
	bind $win.t <Configure> [list ctext::linemapUpdate $win]
	bind $win.l <ButtonPress-1> [list ctext::linemapToggleMark $win %y]
	bind $win.t <KeyRelease-Return> [list after 0 [list ctext::linemapUpdate $win]]
	rename $win _ctextJunk$win
	rename $win.t $win._t

	bind $win <Destroy> "catch {rename $win {}}; [list ctext::event:Destroy $win]"
	
	proc $win {cmd args} "eval ctext::instanceCmd $win \$cmd \$args"

	uplevel #0 "interp alias {} $win.t {} $win"
	
	#If the user wants C comments they should call ctext::enableComments
	ctext::disableComments $win

	ctext::modified $win 0

	return $win
}

proc ctext::event:xscroll {win clientData args} {
    if {$clientData == ""} {
        return
    }
    
    uplevel #0 eval $clientData $args
}

proc ctext::event:yscroll {win clientData args} {
	ctext::linemapUpdate $win
	if {$clientData == ""} {
		return
	}
	
	uplevel #0 eval $clientData $args
}

proc ctext::event:Destroy {win} {
	ctext::clearHighlightClasses $win
}

proc ctext::instanceCmd {self cmd args} {

	#slightly different than the RE used in ctext::comments
	set commentRE {\"|\\|'|/|\*}

	switch -glob -- $cmd {
		append {
			if {[catch {set data [$self._t get sel.first sel.last]}] == 0} {
				clipboard append -displayof $self $data
			}
        }
        
        addcommand {
            if {[llength $args] != 2} {
                return -code error "usage for addcommand: widget addcommand newcommand code"
            }
            set command [lindex $args 0]
            set new_code [lindex $args 1]
            # get the body of this proc
            set body [info body ctext::instanceCmd]
            set lines [split $body \n]
            # build the new proc-code on the fly
            set newproc "proc ctext::instanceCmd \{self cmd args\} \{\n"
            set insertdone 0
            foreach line $lines {
                if {([string first switch $line] == -1) || $insertdone} {
                    append newproc $line\n
                } else  {
                    append newproc $line\n
                    append newproc "$command \{"
                    append newproc $new_code\n
                    append newproc "\}\n"
                    set insertdone 1
                }
            }
            append newproc "\}\n"
            #now lets active the new command
            if {![info complete $newproc]} {
                set fd [open "c:/temp/newproc.tcl" w+]
                puts $fd "incomplete"
                puts $fd $newproc
                close $fd
                return
            } else  {
                set fd [open "c:/temp/newproc.tcl" w+]
                puts $fd "complete"
                puts $fd $newproc
                close $fd
                after idle $newproc
                return $command
            }
        }
        
        cget {
            set arg [string trim [lindex $args 0]]
            switch -- $arg {
                "-linemap" {
                    return [winfo viewable $self.l]
                }
                "-linemapfg" {
                    return [$self.l cget -fg]
                }
                "-linemapbg" {
                    return [$self.l cget -bg]
                }
                "-classes" {
                    return [ctext::getClasses $self]
                }
                "-textWidget" {
                    # we need to call this, if the text-widget is used as an argument
                    # ie. focus [$t cget -textwidget]
                    return $self.t
                }
                "-labelWidget" {
                    return $self.l
                }
                default {
                    return [$self._t cget $arg]
                }
            }
		}
        
        collaps {
            if {[$self._t tag ranges sel] != {}} {
                set range [$self._t tag ranges sel]
                set startIndex [lindex $range 0]
                set endIndex [lindex $range 1]
                set startLine [lindex [split $startIndex "."] 0]
                set endLine [lindex [split $endIndex "."] 0]
                
                set mark elide$startIndex$endIndex
                $self._t mark set $mark $startIndex\+1c
                set index [$self._t index insert]
                regsub {\.} $index "_" index
                # set b [button $self.t.b$index \
                # -image [Bitmap::get cross] \
                # -command "ctext::expand $self $mark $self.t.b$index"]
                set b [button $self.t.b$index \
                        -text "+" \
                        -height 0 \
                        -borderwidth  1 \
                        -highlightthickness 0 \
                        -pady 0 \
                        -padx 1 \
                        -command "ctext::expand $self $mark $self.t.b$index"]
                $b configure -cursor arrow
                $self._t tag configure elide$b -elide 1
                $self._t tag add elide$b $startIndex $endIndex
                $self._t tag remove sel $startIndex $endIndex
                # $self._t tag bind elide$b <KeyPress-Left> [list $self._t mark set insert [lindex [ctext::Text_CurrentRange $self._t elide$b $mark ] 0]-1c]
                $self._t window create $startIndex \
                        -window $b \
                        -pady 0 \
                        -stretch 1 
                ctext::linemapUpdate $self
            }
        }
        
        conf* {
			for {set a 0} {$a < [llength $args]} {incr a 2} {
				set cmdArgs([lindex $args $a]) [lindex $args [expr {$a + 1}]]
			}

			foreach flag {foreground background} short {fg bg} {
				if {[info exists cmdArgs(-$flag)] == 1} {
					set cmdArgs(-$short) $cmdArgs(-$flag)
				}
			}

			#Now remove flags that will confuse text or mess up ctext's linemap callback from -yscrollcommand:
			foreach arg {yscrollcommand xscrollcommand linemap} {
				set loc [lsearch $args -$arg] 
				if {$loc != -1} {
					set firstArgs [lrange $args 0 [expr {$loc - 1}]] 
					set endArgs [lrange $args [expr {$loc + 2}] end]
					set args "$firstArgs $endArgs" 
				}
			}
            
			if {[info exists cmdArgs(-linemap)] == 1 && $cmdArgs(-linemap)} {
                pack $self.l -side left -fill y
			}

			if {[info exists cmdArgs(-linemap)] == 1 && $cmdArgs(-linemap) == 0} {
                pack forget $self.l
            }
            
            if {[info exists cmdArgs(-xscrollcommand)]} {
                $self._t config -xscrollcommand [list ctext::event:xscroll $self $cmdArgs(-xscrollcommand)]
            }

            if {[info exists cmdArgs(-yscrollcommand)]} {
                $self._t config -yscrollcommand [list ctext::event:yscroll $self $cmdArgs(-yscrollcommand)]
			}
			
			if {[info exists cmdArgs(-linemapfg)]} {
				$self.l config -fg $cmdArgs(-linemapfg)
			}
			
            if {[info exists cmdArgs(-linemapbg)]} {
                $self.l config -bg $cmdArgs(-linemapbg)
            }
            
            eval $self._t configure $args
		}

		copy {
			tk_textCopy $self
		} 

		cut {
			if {[catch {set data [$self.t get sel.first sel.last]}] == 0} {
				clipboard clear -displayof $self.t
				clipboard append -displayof $self.t $data
				$self delete [$self.t index sel.first] [$self.t index sel.last]
				ctext::modified $self 1
			}
		}

		delete {
			#delete n.n ?n.n
            #first deal with delete n.n
			set argsLength [llength $args]
			if {$argsLength == 1} {
				set deletePos [lindex $args 0]
				set prevChar [$self._t get $deletePos]
				
				$self._t delete $deletePos
				set char [$self._t get $deletePos]
				
				set prevSpace [ctext::findPreviousSpace $self._t $deletePos]
				set nextSpace [ctext::findNextSpace $self._t $deletePos]
				
				set lineStart [$self._t index "$deletePos linestart"]
				set lineEnd [$self._t index "$deletePos lineend"]
				
				if {[string equal $prevChar "#"] || [string equal $char "#"]} {
					set removeStart $lineStart
					set removeEnd $lineEnd
				} else {
					set removeStart $prevSpace
					set removeEnd $nextSpace
				}
				
				foreach tag [$self._t tag names] {
					if {[string equal $tag "_cComment"] != 1} {
						$self._t tag remove $tag $removeStart $removeEnd
					}
				}
				
				set checkStr "$prevChar[set char]"
				
				if {[regexp $commentRE $checkStr]} {
					after idle [list ctext::comments $self]
				}
				ctext::highlight $self $lineStart $lineEnd
				ctext::linemapUpdate $self
			} elseif {$argsLength == 2} {
				#now deal with delete n.n ?n.n?
				set deleteStartPos [lindex $args 0]
				set deleteEndPos [lindex $args 1]
				
				set data [$self._t get $deleteStartPos $deleteEndPos]
				
				set lineStart [$self._t index "$deleteStartPos linestart"]
				eval $self._t delete $args
                set lineEnd [$self._t index "$deleteStartPos lineend"]
				foreach tag [$self._t tag names] {
					if {[string equal $tag "_cComment"] != 1} {
						$self._t tag remove $tag $lineStart $lineEnd
					}
				}
				
				if {[regexp $commentRE $data]} {
					after idle [list ctext::comments $self]
				}
				
				ctext::highlight $self $lineStart $lineEnd
				if {[string first "\n" $data] >= 0} {
					ctext::linemapUpdate $self
				}
			} else {
				return -code error "invalid argument(s) sent to $self delete: $args"
			}
            ctext::modified $self 1
        }
        
        expandall {
            foreach tagname [$self._t tag names] {
                if {[string first "elide" $tagname] != -1} {
                    $self._t tag delete $tagname
                }
            }
            foreach b [$self._t window names] {
                destroy $b
            }
            after idle [list ctext::linemapUpdate $self]
        }
        
		fastdelete {
			eval $self._t delete $args
			ctext::modified $self 1
			after idle [list ctext::linemapUpdate $self]
		}
		
		fastinsert {
			eval $self._t insert $args
			ctext::modified $self 1
			after idle [list ctext::linemapUpdate $self]
		}
		
		highlight {
			ctext::highlight $self [lindex $args 0] [lindex $args 1]
			ctext::comments $self
		}

		insert {
			if {[llength $args] < 2} {
				return -code error "please use at least 2 arguments to $self insert"
			}
			set insertPos [lindex $args 0]  
			set prevChar [$self._t get "$insertPos - 1 chars"]
			set nextChar [$self._t get $insertPos]
			set lineStart [$self._t index "$insertPos linestart"]
			set prevSpace [ctext::findPreviousSpace $self._t ${insertPos}-1c]
			set data [lindex $args 1]   
			eval $self._t insert $args 

			set nextSpace [ctext::findNextSpace $self._t insert]
			set lineEnd [$self._t index "insert lineend"] 
			 
			if {[$self._t compare $prevSpace < $lineStart]} {
				set prevSpace $lineStart
			}

			if {[$self._t compare $nextSpace > $lineEnd]} {
				set nextSpace $lineEnd
			}
			
			foreach tag [$self._t tag names] { 
				if {[string equal $tag "_cComment"] != 1} {
					$self._t tag remove $tag $prevSpace $nextSpace\-1c 
				}
			} 

			set REData $prevChar
			append REData $data
			append REData $nextChar
			if {[regexp $commentRE $REData]} {
				after idle [list ctext::comments $self]
			}
			
			after idle [list ctext::highlight $self $lineStart $lineEnd]
			after idle [list ctext::linemapUpdate $self]
			switch -- $data {
				"\}" {
					ctext::matchPair $self "\\\{" "\\\}" "\\"
				}
				"\]" {
					ctext::matchPair $self "\\\[" "\\\]" "\\"
				}
				"\)" {
					ctext::matchPair $self "\\(" "\\)" ""
				}
				"\"" {
					ctext::matchQuote $self
				}
			}
			ctext::modified $self 1

			if {[string first "\n" $data] >= 0} {
				ctext::linemapUpdate $self
			}
		}

		paste {
			tk_textPaste $self 
			ctext::modified $self 1
		}


		
        default {
                return [uplevel 2 $self._t $cmd $args]
		}
	}
}

proc ctext::tag:blink {win count} {
	if {$count & 1} {
		$win tag configure _blink -foreground [$win cget -bg] -background [$win cget -fg]
	} else {
		$win tag configure _blink -foreground [$win cget -fg] -background [$win cget -bg]
	}

	if {$count == 4} {
		$win tag delete _blink 1.0 end
		return
	}

	incr count
	after 50 [list ctext::tag:blink $win $count]
}

proc ctext::matchPair {win str1 str2 escape} {
    return
	set prevChar [$win get "insert - 2 chars"]
	
	if {[string equal $prevChar $escape]} {
		#The char that we thought might be the end is actually escaped.
		return
	}

	set searchRE "[set str1]|[set str2]"
	set count 1
	
	set pos [$win index "insert - 1 chars"]
	set endPair $pos
	set lastFound ""
	while 1 {
		set found [$win search -backwards -regexp $searchRE $pos]
		
		if {$found == "" || [$win compare $found > $pos]} {
			return
		}

		if {$lastFound != "" && [$win compare $found == $lastFound]} {
			#The search wrapped and found the previous search
			return
		}
		
		set lastFound $found
		set char [$win get $found]
		set prevChar [$win get "$found - 1 chars"]
		set pos $found

		if {[string equal $prevChar $escape]} {
			continue
		} elseif {[string equal $char [subst $str2]]} {
			incr count
		} elseif {[string equal $char [subst $str1]]} {
			incr count -1
			if {$count == 0} {
				set startPair $found
				break
			} 
		} else {
			#This shouldn't happen.  I may in the future make it return -code error
			puts stderr "ctext seems to have encountered a bug in ctext::matchPair"
			return
		}
	}
	
	$win tag add _blink $startPair
	$win tag add _blink $endPair
	ctext::tag:blink $win 0
}

proc ctext::matchQuote {win} {
    return
	set endQuote [$win index insert]
	set start [$win index "insert - 1 chars"]
	
	if {[$win get "$start - 1 chars"] == "\\"} {
		#the quote really isn't the end
		return
	}
	set lastFound ""
	while 1 {
		set startQuote [$win search -backwards \" $start]
		if {$startQuote == "" || [$win compare $startQuote > $start]} {
			#The search found nothing or it wrapped.
			return
		}

		if {$lastFound != "" && [$win compare $lastFound == $startQuote]} {
			#We found the character we found before, so it wrapped.
			return
		}
		set lastFound $startQuote
		set start [$win index "$startQuote - 1 chars"]
		set prevChar [$win get $start]

		if {$prevChar == "\\"} {
			continue
		}
		break
	}
	
	if {[$win compare $endQuote == $startQuote]} {
		#probably just \"
		return
	}
	
	$win tag add _blink $startQuote $endQuote
	ctext::tag:blink $win 0
}

proc ctext::enableComments {win} {
	$win tag configure _cComment -foreground khaki
}
proc ctext::disableComments {win} {
	catch {$win tag delete _cComment}
}

proc ctext::comments {win} {
	#puts CTEXT::COMMENTS
	
	if {[catch {$win tag cget _cComment -foreground}]} {
		#C comments are disabled
		return
	}

	set startIndex 1.0
	set commentRE {\\\\|\"|\\\"|\\'|'|/\*|\*/}
	set commentStart 0
	set isQuote 0
	set isSingleQuote 0
	set isComment 0
	$win tag remove _cComment 1.0 end
	while 1 {
		set index [$win search -count length -regexp $commentRE $startIndex end]
		
		if {$index == ""} {
			break
		}
		
		set endIndex [$win index "$index + $length chars"]
		set str [$win get $index $endIndex]
		set startIndex $endIndex

		if {$str == "\\\\"} {
			continue
		} elseif {$str == "\\\""} {
			continue
		} elseif {$str == "\\'"} {
			continue
		} elseif {$str == "\"" && $isComment == 0 && $isSingleQuote == 0} {
			if {$isQuote} {
				set isQuote 0
			} else {
				set isQuote 1
			}
		} elseif {$str == "'" && $isComment == 0 && $isQuote == 0} {
			if {$isSingleQuote} {
				set isSingleQuote 0
			} else {
				set isSingleQuote 1
			}
		} elseif {$str == "/*" && $isQuote == 0 && $isSingleQuote == 0} {
			if {$isComment} {
				#comment in comment
				break
			} else {
				set isComment 1
				set commentStart $index
			}
		} elseif {$str == "*/" && $isQuote == 0 && $isSingleQuote == 0} {
			if {$isComment} {
				set isComment 0
				$win tag add _cComment $commentStart $endIndex
				$win tag raise _cComment
			} else {
				#comment end without beginning
				break
			}
		}
	}
}

proc ctext::addHighlightClass {win class fgcolor keywords} {
    if {![catch {font create $class}]} {
        eval font configure $class [$win cget -font]
    }
    foreach word $keywords {
        set ::ctext::highlight${win}($word) "$class $fgcolor"
    }
    $win tag configure $class -font $class -foreground $fgcolor
}

proc ctext::delHighlightClass {win class} {
    foreach item [array names ::ctext::highlight${win}] {
        if {$class == [lindex [set ::ctext::highlight${win}($item)] 0]} {
            unset ::ctext::highlight${win}($item)
        }
    }
    font delete $class
}

proc ctext::getHighlightClass {win class} {
    foreach item [array names ::ctext::highlight${win}] {
        if {$class == [lindex [set ::ctext::highlight${win}($item)] 0]} {
            lappend class_items $item
        }
    }
    return $class_items
}
#For [ ] { } # etc.
proc ctext::addHighlightClassForSpecialChars {win class fgcolor chars} {
    if {![catch {font create $class}]} {
        eval font configure $class [$win cget -font]
    }
	foreach char [split $chars ""] {
        set ::ctext::highlightSpecialChars${win}($char) "$class $fgcolor"
    }
    $win tag configure $class -font $class -foreground $fgcolor 
}

proc ctext::delHighlightClassForSpecialChars {win class} {
    foreach item [array names ::ctext::highlightSpecialChars${win}] {
        if {$class == [lindex [set ::ctext::highlightSpecialChars${win}($item)] 0]} {
            unset ::ctext::highlightSpecialChars${win}($item)
        }
    }
    font delete $class
}

proc ctext::getHighlightClassForSpecialChars {win class} {
    foreach item [array names ::ctext::highlightSpecialChars${win}] {
        if {$class == [lindex [set ::ctext::highlightSpecialChars${win}($item)] 0]} {
            lappend class_items $item
        }
    }
    return $class_items
}

proc ctext::addHighlightClassForRegexp {win class fgcolor re} {
    if {![catch {font create $class}]} {
        eval font configure $class [$win cget -font]
    }
    set ::ctext::highlightRegexp${win}($class) "$fgcolor $re"
    $win tag configure $class -font $class -foreground $fgcolor
}

proc ctext::delHighlightClassForRegexp {win class} {
    foreach item [array names ctext::delHighlightClassForRegexp${win}] {
        if {$class == $item} {
            unset ::ctext::ctext::delHighlightClassForRegexp${win}($item)
        }
    }
    font delete $class
}

proc ctext::getHighlightClassForRegexp {win class} {
    foreach item [array names ::ctext::ctext::delHighlightClassForRegexp${win}] {
        if {$class == $item} {
            set re [lindex [set ::ctext::ctext::delHighlightClassForRegexp${win}($item)] 1]
            return $re
        }
    }
    return {}
}

#For things like $blah 
proc ctext::addHighlightClassWithOnlyCharStart {win class fgcolor char} {
    if {![catch {font create $class}]} {
        eval font configure $class [$win cget -font]
    }
    set ::ctext::highlightCharStart${win}($char) "$class $fgcolor"
    $win tag configure $class -font $class -foreground $fgcolor
}

proc ctext::delHighlightClassWithOnlyCharStart {win class} {
    foreach item [array names ::ctext::highlightCharStart${win}] {
        if {$class == [lindex [set ::ctext::highlightCharStart${win}($item)] 0]} {
            unset ::ctext::highlightCharStart${win}($item)
        }
    }
    font delete $class
}

proc ctext::getHighlightClassWithOnlyCharStart {win class} {
    foreach item [array names ::ctext::highlightCharStart${win}] {
        if {$class == [lindex [set ::ctext::highlightCharStart${win}($item)] 0]} {
            lappend class_items $item
        }
    }
    return $class_items
}

proc ctext::getClasses {win} {
    set classes {}
    foreach item [array names ::ctext::highlight${win}] {
        set class [lindex [set ::ctext::highlight${win}($item)] 0]
        if {[lsearch $classes $class] == -1} {
            lappend classes $class
        }
    }
    foreach item [array names ::ctext::highlightSpecialChars${win}] {
        set class [lindex [set ::ctext::highlightSpecialChars${win}($item)] 0]
        if {[lsearch $classes $class] == -1} {
            lappend classes $class
        }
    }
        
    foreach class [array names ::ctext::highlightRegexp${win}] {
        if {[lsearch $classes $class] == -1} {
            lappend classes $class
        }
    }
    foreach item [array names ::ctext::highlightCharStart${win}] {
        set class [lindex [set ::ctext::highlightCharStart${win}($item)] 0]
        if {[lsearch $classes $class] == -1} {
            lappend classes $class
        }
    }
    return $classes
}

proc ctext::findNextChar {win index char} {
	set i [$win index "$index + 1 chars"]
	set lineend [$win index "$i lineend"]
	while {1} {
		set ch [$win get $i]
		if {[$win compare $i >= $lineend]} {
			return ""
		}
		if {$ch == $char} {
			return $i
		}
		set i [$win index "$i + 1 chars"]
	}
}


proc ctext::findNextSpace {win index} {
	set i [$win index $index]
	set lineStart [$win index "$i linestart"]
	set lineEnd [$win index "$i lineend"]
	#Sometimes the lineend fails (I don't know why), so add 1 and try again.
	if {[$win compare $lineEnd == $lineStart]} {
		set lineEnd [$win index "$i + 1 chars lineend"]
	}

	while {1} {
		set ch [$win get $i]

		if {[$win compare $i >= $lineEnd]} {
			set i $lineEnd
			break
		}

		if {[string is space $ch]} { 
			break
		}
		set i [$win index "$i + 1 chars"]
	}
	return $i
}


proc ctext::findPreviousSpace {win index} {
	set i [$win index $index]
	set lineStart [$win index "$i linestart"]
	while {1} {
		set ch [$win get $i]

		if {[$win compare $i <= $lineStart]} {
			set i $lineStart
			break
		}

		if {[string is space $ch]} {
			break
		}
		
		set i [$win index "$i - 1 chars"]
	}
	return $i
}

proc ctext::clearHighlightClasses {win} {
	#no need to catch, because array unset doesn't complain
	#puts [array exists ::ctext::highlight$win]

	array unset ::ctext::highlight$win
	array unset ::ctext::highlightCharStart$win
	array unset ::ctext::highlightSpecialChars$win
	array unset ::ctext::highlightRegexp$win
}

#This is a proc designed to be overwritten by the user.
#It can be used to update a cursor or animation while
#the text is being highlighted.
proc ctext::update {} {

}

proc ctext::highlight {win start end} {
    variable highlightOn
    
    if {$highlightOn == 0} {
        return
    }
    
	set si $start
		
    set twin "$win._t"
    
    foreach tag [$twin tag names] {
        $twin tag remove $tag $start $end
    }
	
	#The number of times the loop has run.
	set numTimes 0
	set numUntilUpdate 600

	while {1} {
        set res [$twin search -count length -regexp -- {([^\s\(\{\[\}\]\)\.\t\n\r;\"'\|,]+)} $si $end]
		if {$res == ""} { 
			break 
		} 
		
		set wordEnd [$twin index "$res + $length chars"]
		set word [$twin get $res $wordEnd] 
		set firstOfWord [string index $word 0]

		if {[info exists ::ctext::highlight${win}($word)] == 1} {
			set wordAttributes [set ::ctext::highlight${win}($word)]
            foreach {tagClass fgcolor} $wordAttributes {break}
			
			$twin tag add $tagClass $res $wordEnd

		} elseif {[info exists ::ctext::highlightCharStart${win}($firstOfWord)] == 1} {
			set wordAttributes [set ::ctext::highlightCharStart${win}($firstOfWord)]
            foreach {tagClass fgcolor} $wordAttributes {break}
			
			$twin tag add $tagClass $res $wordEnd 
		}
		set si "$wordEnd"

		incr numTimes
		if {$numTimes >= $numUntilUpdate} {
			ctext::update
			set numTimes 0
		}
	}
	
	foreach {ichar tagInfo} [array get ::ctext::highlightSpecialChars$win] {
		set si $start
        foreach {tagClass fgcolor} $tagInfo {break}

		while {1} {
			set res [$twin search -- $ichar $si $end] 
			if {$res == ""} { 
				break 
			} 
			set wordEnd [$twin index "$res + 1 chars"]
	
			$twin tag add $tagClass $res $wordEnd
			set si $wordEnd

			incr numTimes
			if {$numTimes >= $numUntilUpdate} {
				ctext::update
				set numTimes 0
			}
		}
	}
	
	foreach {tagClass tagInfo} [array get ::ctext::highlightRegexp$win] {
		set si $start
        foreach {fgcolor re} $tagInfo {break}
		
		while {1} {
			set res [$twin search -count length -regexp -- $re $si $end] 
			if {$res == ""} { 
				break 
			} 
		
			set wordEnd [$twin index "$res + $length chars"]
			$twin tag add $tagClass $res $wordEnd
			set si $wordEnd
			
			incr numTimes
			if {$numTimes >= $numUntilUpdate} {
				ctext::update
				set numTimes 0
			}
		}
	}
}


proc ctext::linemapToggleMark {win y} {
	#The list of existing marks:
		
	set markChar [$win.l index @0,$y] 
	set lineSelected [lindex [split $markChar .] 0]
	set line [$win.l get $lineSelected.0 $lineSelected.end]

	if {$line == ""} {
		return
	}
	
	if {[info exists ::ctext::toggled${win}($line)] == 1} { 
		#It's already marked, so unmark it.
		array unset ::ctext::toggled$win $line
		ctext::linemapUpdate $win
	} else {
		#This means that the line isn't toggled, so toggle it.
		array set ::ctext::toggled$win [list $line {}]
		$win.l tag add lmark $markChar [$win.l index "$markChar lineend"] 
		$win.l tag configure lmark -background yellow -foreground black
	}
}


#args is here because -yscrollcommand may call it
proc ctext::linemapUpdate {win args} {
	
	if {[winfo exists $win.l] != 1} { 
		return
	}

	set pixel 0
	set lastLine {}
	set lineList [list]
	set fontMetrics [font metrics [$win._t cget -font]]
	set incrBy [expr {1 + ([lindex $fontMetrics 5] / 2)}]
	while {$pixel < [winfo height $win.l]} {
		set idx [$win._t index @0,$pixel]

		if {$idx != $lastLine} {
			set line [lindex [split $idx .] 0]
			set lastLine $idx
			$win.l config -width [string length $line]
			lappend lineList $line
		}	
		incr pixel $incrBy 
	} 

	$win.l delete 1.0 end
	set lastLine {}
	foreach line $lineList {
		if {$line == $lastLine} {
			$win.l insert end "\n" 
		} else {
			if {[info exists ::ctext::toggled${win}($line)] == 1} { 
				$win.l insert end "$line\n" lmark
			} else {
				$win.l insert end "$line\n"
			}
		}
		set lastLine $line
	}
}

proc ctext::modified {win value} {
	set ::ctext::modified$win $value
	event generate $win <<Modified>>
	return $value
}

proc ctext::bind {win args} {
    if {[catch {winfo class $win}] || [winfo class $win ] != "Ctext"} {
        uplevel #0 eval [list ::orig_bind $win $args]
    } else  {
        uplevel #0 eval [list ::orig_bind $win.t $args]
    }
}

proc ctext::focus {win args} {
    if {[catch {winfo class $win}] || [winfo class $win ] != "Ctext"} {
        uplevel eval [list ::o_focus $win $args]
    } else  {
        uplevel eval [list ::o_focus $win\.t $args]
    }
}

proc ctext::Text_CurrentRange { t tag mark } {
    set range [$t tag prevrange $tag [$t index $mark]]
    set end [lindex $range 1]
    if {[llength $range] == 0 || [$t compare [$t index $mark] > $end]} {
        # This occurs when the mark is at the
        # very beginning of the node
        set range [$t tag nextrange $tag [$t index $mark]]
        if {[llength $range] == 0 ||
            [$t compare [$t index $mark] < [lindex $range 0]]} {
            return {}
        }
    }
    return $range
}

proc ctext::expand {win mark button} {
    set range [ctext::Text_CurrentRange $win._t elide$button $mark ]
    set startIndex [lindex $range 0]
    set endIndex [lindex $range 1]
    $win._t tag remove elide$button $startIndex $endIndex
    $win._t mark unset $mark
    destroy $button
    ctext::linemapUpdate $win
}



