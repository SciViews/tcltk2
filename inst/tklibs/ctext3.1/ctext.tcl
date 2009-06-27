# By George Peter Staplin
# See also the README for a list of contributors
# RCS: @(#) $Id: ctext.tcl,v 1.4 2006/09/06 01:40:04 hobbs Exp $

package require Tk
package provide ctext 3.1

namespace eval ctext {}

## Added by Philippe Grosjean: a couple of syntax highlighters
# C code highlighting
proc ctext::HighlightC {win} {
	set fnt [font configure TkFixedFont -family]
	set size [font configure TkFixedFont -size]
	$win configure -font TkFixedFont \
			-tabs [font measure TkFixedFont "    "] ;# Tabs are 4 chars long
	
	# Reserved words
	ctext::addHighlightClass $win _cReserved green4 [list \
		namespace while for if else do switch case]
	
	# Types
	ctext::addHighlightClass $win _cType darkred [list \
		int char u_char u_int long double float typedef unsigned signed void]
	$win tag configure _cType -font "{$fnt} $size bold"
	
	# Macros
	ctext::addHighlightClass $win _cMacro navy [list \
		#define #undef #if #ifdef #ifndef #endif #elseif #include #import #exclude]

	# Numbers
	ctext::addHighlightClassForRegexp $win _cNumber black\
		{\m[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?(?![a-zA-Z0-9_.])}
	$win tag configure _cNumber -font "{$fnt} $size bold"
	
	# Strings
	ctext::addHighlightClassForRegexp $win _cDString khaki4\
		{"[^"\\]*(\\.[^"\\]*)*"}
	ctext::addHighlightClassForRegexp $win _cSString khaki4\
		{'[^'\\]*(\\.[^'\\]*)*'}

	# Brackets
	ctext::addHighlightClassForSpecialChars $win _cBracket red {[]{}();}

	# Operators
	ctext::addHighlightClassForSpecialChars $win _cOperator black {+=*-/&^%!|<>}

	# Single line comments
	ctext::addHighlightClassForRegexp $win _cSComment gray50 {//[^\n\r]*}
	$win tag configure _cSComment -font "{$fnt} $size italic"
	
	# Multi-lines comments
	ctext::enableComments $win
	$win tag configure _cComment -font "{$fnt} $size italic" \
		-foreground gray50
}

# R code highlighting
proc ctext::HighlightR {win} {
	set fnt [font configure TkFixedFont -family]
	set size [font configure TkFixedFont -size]
	# The default font and tabs of four characters
	$win configure -font TkFixedFont \
		-tabs [font measure TkFixedFont "    "]
	
	# Numbers
	ctext::addHighlightClassForRegexp $win _cNumber black\
		{\m[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?(?![a-zA-Z0-9_.])}
	$win tag configure _cNumber -font "{$fnt} $size bold"
	
	# Functions in R are followed by '('
	ctext::addHighlightClassForRegexp $win _cFunction green4\
		{\m[a-zA-Z.][a-zA-Z0-9._]*(?=\s*\()}

	# Generic functions
	ctext::addHighlightClassForRegexp $win _cFunction2 green4\
		{\m(with|window|wilcox.test|weights|weekdays|vcov|var.test|upgrade|update|unstack|unique|TukeyHSD|tsSmooth|tsdiag|truncate|transform|toString|time|text|terms|tail|t.test|t|summary|sum|subset|str|start|stack|sqrt|split|solve|show|seq|se.contrast|se.aovlist|se.aov|scale|rstudent|rstandard|rowsum|row.names|round|rev|residuals|residrep|relevel|rbind|range|quarters|quantile|quade.test|qqnorm|proj|profile|print|princomp|predict|prcomp|ppr|points|plot|persp|pacf|Ops|open|names|months|model.matrix|model.frame|merge|mean|logLik|lines|length|labels|lag|kruskal.test|kappa|julian|is.na|image|hist|head|hatvalues|friedman.test|frequency|formula|format|flush|fligner.test|fitted.values|fitted|family|extractAIC|end|effects|edit|duplicated|dummy.coef|drop1|dimnames|dim|diff|dfbetas|dfbeta|deviance|determinant|deriv3|deriv|density|deltat|cut|cor.test|cophenetic|cooks.distance|contour|confint|conditionMessage|conditionCall|coerce|coefficients|coef|cbind|c|by|boxplot|biplot|bartlett.test|barplot|as.vector|as.ts|as.table|as.symbol|as.stepfun|as.single|as.real|as.qr|as.POSIXlt|as.POSIXct|as.pairlist|as.ordered|as.numeric|as.null|as.name|as.matrix|as.logical|as.list|as.integer|as.hclust|as.function|as.formula|as.factor|as.expression|as.environment|as.double|as.dist|as.difftime|as.dendrogram|as.Date|as.data.frame|as.complex|as.character|as.call|as.array|any|ansari.test|anova|all.equal|all|AIC|aggregate|add1|abs)(?=\s*\()}
	$win tag configure _cFunction2 -font "{$fnt} $size italic"
	
	# Reserved constants
	ctext::addHighlightClassForRegexp $win _cConstant darkred\
		{\m(TRUE|FALSE|NULL|NA|NaN|Inf)(?![a-zA-Z0-9_.])}
	
	# Reserved words
	ctext::addHighlightClass $win _cReserved green4 [list \
		while repeat next in if function for else break]
	$win tag configure _cReserved -font "{$fnt} $size bold"

	# Brackets
	ctext::addHighlightClassForSpecialChars $win _cBracket red {[]{}();}

	### TODO: add _cOperator
	
	# Strings (spanning on multiple lines, but only works for single line!)
	ctext::addHighlightClassForRegexp $win _cDString khaki4\
		{"[^"\\]*(\\.[^"\\]*)*"}
	ctext::addHighlightClassForRegexp $win _cSString khaki4\
		{'[^'\\]*(\\.[^'\\]*)*'}
	ctext::addHighlightClassForRegexp $win _cBString khaki4 {`[^`]*`}
	
	# Comments (single line)
	ctext::addHighlightClassForRegexp $win _cSComment gray50 {#[^\n\r]*}
	$win tag configure _cSComment -font "{$fnt} $size italic"
	
	# Output text (single line)
	ctext::addHighlightClassForRegexp $win _cOutput navy {#![^\n\r]*}
	$win tag configure _cOutput -font "{$fnt} $size"

	# Prompts
	ctext::addHighlightClassForRegexp $win _cPrompt red {^ ?[+|>] }
	$win tag configure _cPrompt -font "{$fnt} $size bold"
	
	### TODO...
	# Add links to functions
	# Intelligent tabs: copy, but indent if { or ( and unindent if } or )
}

# R help highlighting
proc ctext::HighlightRhelp {win} {
	set fnt [font configure TkFixedFont -family]
	set size [font configure TkFixedFont -size]
	
	# First, configure for R code
	HighlightR $win

	# Configure tabulations for one characters
	# The default fonttext and tabs of two characters for font/size
	$win configure -font TkFixedSize \
		-tabs [font measure TkFixedSize "  "]

	## Additional styles
	# BigTitle (ending with \t\t)
	ctext::addHighlightClassForRegexp $win _cBigTitle darkred {^[^\t]+\t\t$}
	$win tag configure _cBigTitle -font TkBigTitleFont
	
	# Title (ending with \t)
	ctext::addHighlightClassForRegexp $win _cTitle darkred {^[^\t]+\t$}
	$win tag configure _cTitle -font TkTitleFont
		
	# Text (starting with \t)
	ctext::addHighlightClassForRegexp $win _cText black {^\t[^\t]+$}
	$win tag configure _cBigTitle -font TkTextFont
	
	# Keyword (followed by :\t)
	ctext::addHighlightClassForRegexp $win _cKeyword gray50\
		{^ *[a-zA-Z.][a-zA-Z0-9._]*(?=:\t)}
	$win tag configure _cKeyword -font TkFixedFont	
	
	# Definition of a keyword (starting with :\t)
	ctext::addHighlightClassForRegexp $win _cDefinition black {:\t[^\t]+$}
	$win tag configure _cDefinition -font TkTextFont
	
	# Links (surrounded by <<x>>, or ''x'')
	ctext::addHighlightClassForRegexp $win _cLink navy\
		{<<[^\>]+>>}
	ctext::addHighlightClassForRegexp $win _cLink navy\
		{''[^']+''}
		
	# Emails surrounded by <me@mynet.org>
	ctext::addHighlightClassForRegexp $win _cLinkExt navy\
		{<[-\w\d_.]+@([-\w\d]+\.)+([-\w\d]+\.)*([-\w\d]+\.)*[a-zA-Z]{2,6}>}
	
	# External links to URLs
	ctext::addHighlightClassForRegexp $win _cLinkExt navy\
		{(http|https|ftp)://[-\w\d\.]{4,}\S*[\w\d=/](?=[\s\)\]\.:;!'"])}
}
	
#win is used as a unique token to create arrays for each ctext instance
proc ctext::getAr {win suffix name} {
	set arName __ctext[set win][set suffix]
	uplevel [list upvar #0 $arName $name]
	return $arName
}

proc ctext {win args} {
	if {[llength $args] & 1} {
		return -code error "invalid number of arguments given to ctext (uneven number after window) : $args"
	}

	frame $win -class Ctext

	set tmp [text .__ctextTemp]

	ctext::getAr $win config ar

	set ar(-fg) [$tmp cget -foreground]
	set ar(-bg) [$tmp cget -background]
	set ar(-font) [$tmp cget -font]
	set ar(-relief) [$tmp cget -relief]
	destroy $tmp
	set ar(-yscrollcommand) ""
	set ar(-linemap) 1
	set ar(-linemapfg) $ar(-fg)
	set ar(-linemapbg) $ar(-bg)
	set ar(-linemap_mark_command) {}
	set ar(-linemap_markable) 1
	set ar(-linemap_select_fg) black
	set ar(-linemap_select_bg) yellow
	set ar(-highlight) 1
	set ar(win) $win
	set ar(modified) 0

	set ar(ctextFlags) [list -yscrollcommand -linemap -linemapfg -linemapbg \
-font -linemap_mark_command -highlight -linemap_markable -linemap_select_fg \
-linemap_select_bg]

	array set ar $args

	foreach flag {foreground background} short {fg bg} {
		if {[info exists ar(-$flag)] == 1} {
			set ar(-$short) $ar(-$flag)
			unset ar(-$flag)
		}
	}

	#Now remove flags that will confuse text and those that need modification:
	foreach arg $ar(ctextFlags) {
		if {[set loc [lsearch $args $arg]] >= 0} {
			set args [lreplace $args $loc [expr {$loc + 1}]]
		}
	}

	text $win.l -font $ar(-font) -width 1 -height 1 \
		-relief $ar(-relief) -fg $ar(-linemapfg) \
		-bg $ar(-linemapbg) -takefocus 0

	set topWin [winfo toplevel $win]
	bindtags $win.l [list $win.l $topWin all]

	if {$ar(-linemap) == 1} {
		grid $win.l -sticky ns -row 0 -column 0
	}

	set args [concat $args [list -yscrollcommand [list ctext::event:yscroll $win $ar(-yscrollcommand)]]]

	#escape $win, because it could have a space
	eval text \$win.t -font \$ar(-font) $args

	grid $win.t -row 0 -column 1 -sticky news
	grid rowconfigure $win 0 -weight 100
	grid columnconfigure $win 1 -weight 100

	bind $win.t <Configure> [list ctext::linemapUpdate $win]
	bind $win.l <ButtonPress-1> [list ctext::linemapToggleMark $win %y]
	bind $win.t <KeyRelease-Return> [list ctext::linemapUpdate $win]
	rename $win __ctextJunk$win
	rename $win.t $win._t

	bind $win <Destroy> [list ctext::event:Destroy $win %W]
	bindtags $win.t [linsert [bindtags $win.t] 0 $win]

	interp alias {} $win {} ctext::instanceCmd $win
	interp alias {} $win.t {} $win

	#If the user wants C comments they should call ctext::enableComments
	ctext::disableComments $win
	ctext::modified $win 0
	ctext::buildArgParseTable $win

	return $win
}
### Added from ASED 3.0 version of ctext
proc ctext::event:xscroll {win clientData args} {
    if {$clientData == ""} {
        return
    }
    
    uplevel #0 eval $clientData $args
}
### End of addition
proc ctext::event:yscroll {win clientData args} {
	ctext::linemapUpdate $win

	if {$clientData == ""} {
		return
	}
	uplevel #0 $clientData $args
}

proc ctext::event:Destroy {win dWin} {
	if {![string equal $win $dWin]} {
		return
	}
	catch {rename $win {}}
	interp alias {} $win.t {}
	ctext::clearHighlightClasses $win
	array unset [ctext::getAr $win config ar]
}

#This stores the arg table within the config array for each instance.
#It's used by the configure instance command.
proc ctext::buildArgParseTable win {
	set argTable [list]

	lappend argTable any -linemap_mark_command {
		set configAr(-linemap_mark_command) $value
		break
	}

	lappend argTable {1 true yes} -linemap {
		grid $self.l -sticky ns -row 0 -column 0
		grid columnconfigure $self 0 \
			-minsize [winfo reqwidth $self.l]
		set configAr(-linemap) 1
		break
	}

	lappend argTable {0 false no} -linemap {
		grid forget $self.l
		grid columnconfigure $self 0 -minsize 0
		set configAr(-linemap) 0
		break
	}

	lappend argTable any -yscrollcommand {
		set cmd [list $self._t config -yscrollcommand [list ctext::event:yscroll $self $value]]

		if {[catch $cmd res]} {
			return $res
		}
		set configAr(-yscrollcommand) $value
		break
	}

	lappend argTable any -linemapfg {
		if {[catch {winfo rgb $self $value} res]} {
			return -code error $res
		}
		$self.l config -fg $value
		set configAr(-linemapfg) $value
		break
	}

	lappend argTable any -linemapbg {
		if {[catch {winfo rgb $self $value} res]} {
			return -code error $res
		}
		$self.l config -bg $value
		set configAr(-linemapbg) $value
		break
	}

	lappend argTable any -font {
		if {[catch {$self.l config -font $value} res]} {
			return -code error $res
		}
		$self._t config -font $value
		set configAr(-font) $value
		break
	}

	lappend argTable {0 false no} -highlight {
		set configAr(-highlight) 0
		break
	}

	lappend argTable {1 true yes} -highlight {
		set configAr(-highlight) 1
		break
	}

	lappend argTable {0 false no} -linemap_markable {
		set configAr(-linemap_markable) 0
		break
	}

	lappend argTable {1 true yes} -linemap_markable {
		set configAr(-linemap_markable) 1
		break
	}

	lappend argTable any -linemap_select_fg {
		if {[catch {winfo rgb $self $value} res]} {
			return -code error $res
		}
		set configAr(-linemap_select_fg) $value
		$self.l tag configure lmark -foreground $value
		break
	}

	lappend argTable any -linemap_select_bg {
		if {[catch {winfo rgb $self $value} res]} {
			return -code error $res
		}
		set configAr(-linemap_select_bg) $value
		$self.l tag configure lmark -background $value
		break
	}

	ctext::getAr $win config ar
	set ar(argTable) $argTable
}

proc ctext::instanceCmd {self cmd args} {
	#slightly different than the RE used in ctext::comments
	set commentRE {\"|\\|'|/|\*}

	switch -glob -- $cmd {
		append {
			if {[catch {$self._t get sel.first sel.last} data] == 0} {
				clipboard append -displayof $self $data
			}
		}
### Added from ASED version 3.0 of ctext 
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
                
        collapse {
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
### End of addition

		cget {
			set arg [lindex $args 0]
			ctext::getAr $self config configAr

			foreach flag $configAr(ctextFlags) {
				if {[string match ${arg}* $flag]} {
					return [set configAr($flag)]
				}
			}
			return [$self._t cget $arg]
		}

		conf* {
			ctext::getAr $self config configAr

			if {0 == [llength $args]} {
				set res [$self._t configure]
				set del [lsearch -glob $res -yscrollcommand*]
				set res [lreplace $res $del $del]
				foreach flag $configAr(ctextFlags) {
					lappend res [list $flag [set configAr($flag)]]
				}
				return $res
			}

			array set flags {}
			foreach flag $configAr(ctextFlags) {
				set loc [lsearch $args $flag]
				if {$loc < 0} {
					continue
				}

				if {[llength $args] <= ($loc + 1)} {
					#.t config -flag
					return [set configAr($flag)]
				}

				set flagArg [lindex $args [expr {$loc + 1}]]
				set args [lreplace $args $loc [expr {$loc + 1}]]
				set flags($flag) $flagArg
			}

			foreach {valueList flag cmd} $configAr(argTable) {
				if {[info exists flags($flag)]} {
					foreach valueToCheckFor $valueList {
						set value [set flags($flag)]
						if {[string equal "any" $valueToCheckFor]} $cmd \
						elseif {[string equal $valueToCheckFor [set flags($flag)]]} $cmd
					}
				}
			}

			if {[llength $args]} {
				#we take care of configure without args at the top of this branch
				uplevel 1 [linsert $args 0 $self._t configure]
			}
		}

		copy {
			tk_textCopy $self
		}

		cut {
			if {[catch {$self.t get sel.first sel.last} data] == 0} {
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
				set lineEnd [$self._t index "$deletePos + 1 chars lineend"]

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
				set lineEnd [$self._t index "$deleteEndPos + 1 chars lineend"]
				eval \$self._t delete $args

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

### Added from ASED version 3.0 of ctext
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
### End of addition
		fastdelete {
			eval \$self._t delete $args
			ctext::modified $self 1
			ctext::linemapUpdate $self
		}

		fastinsert {
			eval \$self._t insert $args
			ctext::modified $self 1
			ctext::linemapUpdate $self
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
			eval \$self._t insert $args

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
					$self._t tag remove $tag $prevSpace $nextSpace
				}
			}

			set REData $prevChar
			append REData $data
			append REData $nextChar
			if {[regexp $commentRE $REData]} {
				after idle [list ctext::comments $self]
			}

			after idle [list ctext::highlight $self $lineStart $lineEnd]

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
			ctext::linemapUpdate $self
		}

		paste {
			tk_textPaste $self
			ctext::modified $self 1
		}

		edit {
			set subCmd [lindex $args 0]
			set argsLength [llength $args]

			ctext::getAr $self config ar

			if {"modified" == $subCmd} {
				if {$argsLength == 1} {
					return $ar(modified)
				} elseif {$argsLength == 2} {
					set value [lindex $args 1]
					set ar(modified) $value
				} else {
					return -code error "invalid arg(s) to $self edit modified: $args"
				}
			} else {
				#Tk 8.4 has other edit subcommands that I don't want to emulate.
				return [uplevel 1 [linsert $args 0 $self._t $cmd]]
			}
		}

		default {
			return [uplevel 1 [linsert $args 0 $self._t $cmd]]
		}
	}
}

proc ctext::tag:blink {win count} {
	if {$count & 1} {
		$win tag configure __ctext_blink -foreground [$win cget -bg] -background [$win cget -fg]
	} else {
		$win tag configure __ctext_blink -foreground [$win cget -fg] -background [$win cget -bg]
	}

	if {$count == 4} {
		$win tag delete __ctext_blink 1.0 end
		return
	}
	incr count
	after 50 [list ctext::tag:blink $win $count]
}

proc ctext::matchPair {win str1 str2 escape} {
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

	$win tag add __ctext_blink $startPair
	$win tag add __ctext_blink $endPair
	ctext::tag:blink $win 0
}

proc ctext::matchQuote {win} {
### return; #Added in ASED version 3.0 of ctext... why? 
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

	$win tag add __ctext_blink $startQuote $endQuote
	ctext::tag:blink $win 0
}

proc ctext::enableComments {win} {
	$win tag configure _cComment -foreground khaki
}
proc ctext::disableComments {win} {
	catch {$win tag delete _cComment}
}

proc ctext::comments {win} {
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

proc ctext::addHighlightClass {win class color keywords} {
	set ref [ctext::getAr $win highlight ar]
	foreach word $keywords {
		set ar($word) [list $class $color]
	}
	$win tag configure $class

	ctext::getAr $win classes classesAr
	set classesAr($class) [list $ref $keywords]
}

#For [ ] { } # etc.
proc ctext::addHighlightClassForSpecialChars {win class color chars} {
	set charList [split $chars ""]

	set ref [ctext::getAr $win highlightSpecialChars ar]
	foreach char $charList {
		set ar($char) [list $class $color]
	}
	$win tag configure $class

	ctext::getAr $win classes classesAr
	set classesAr($class) [list $ref $charList]
}

proc ctext::addHighlightClassForRegexp {win class color re} {
	set ref [ctext::getAr $win highlightRegexp ar]

	set ar($class) [list $re $color]
	$win tag configure $class

	ctext::getAr $win classes classesAr
	set classesAr($class) [list $ref $class]
}

#For things like $blah
proc ctext::addHighlightClassWithOnlyCharStart {win class color char} {
	set ref [ctext::getAr $win highlightCharStart ar]

	set ar($char) [list $class $color]
	$win tag configure $class

	ctext::getAr $win classes classesAr
	set classesAr($class) [list $ref $char]
}

proc ctext::deleteHighlightClass {win classToDelete} {
	ctext::getAr $win classes classesAr

	if {![info exists classesAr($classToDelete)]} {
		return -code error "$classToDelete doesn't exist"
	}

	foreach {ref keyList} [set classesAr($classToDelete)] {
		upvar #0 $ref refAr
		foreach key $keyList {
			if {![info exists refAr($key)]} {
				continue
			}
			unset refAr($key)
		}
	}
	unset classesAr($classToDelete)
}

proc ctext::getHighlightClasses win {
	ctext::getAr $win classes classesAr

	array names classesAr
}

proc ctext::findNextChar {win index char} {
	set i [$win index "$index + 1 chars"]
	set lineend [$win index "$i lineend"]
	while 1 {
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

	ctext::getAr $win highlight ar
	array unset ar

	ctext::getAr $win highlightSpecialChars ar
	array unset ar

	ctext::getAr $win highlightRegexp ar
	array unset ar

	ctext::getAr $win highlightCharStart ar
	array unset ar

	ctext::getAr $win classes ar
	array unset ar
}

#This is a proc designed to be overwritten by the user.
#It can be used to update a cursor or animation while
#the text is being highlighted.
proc ctext::update {} {

}

proc ctext::highlight {win start end} {
	ctext::getAr $win config configAr

	if {!$configAr(-highlight)} {
		return
	}

	set si $start
	set twin "$win._t"

	#The number of times the loop has run.
	set numTimesLooped 0
	set numUntilUpdate 600

	ctext::getAr $win highlight highlightAr
	ctext::getAr $win highlightSpecialChars highlightSpecialCharsAr
	ctext::getAr $win highlightRegexp highlightRegexpAr
	ctext::getAr $win highlightCharStart highlightCharStartAr

	while 1 {
		set res [$twin search -count length -regexp -- {([^\s\(\{\[\}\]\)\.\t\n\r;\"'\|,]+)} $si $end]
		if {$res == ""} {
			break
		}

		set wordEnd [$twin index "$res + $length chars"]
		set word [$twin get $res $wordEnd]
		set firstOfWord [string index $word 0]

		if {[info exists highlightAr($word)] == 1} {
			set wordAttributes [set highlightAr($word)]
			foreach {tagClass color} $wordAttributes break

			$twin tag add $tagClass $res $wordEnd
			$twin tag configure $tagClass -foreground $color

		} elseif {[info exists highlightCharStartAr($firstOfWord)] == 1} {
			set wordAttributes [set highlightCharStartAr($firstOfWord)]
			foreach {tagClass color} $wordAttributes break

			$twin tag add $tagClass $res $wordEnd
			$twin tag configure $tagClass -foreground $color
		}
		set si $wordEnd

		incr numTimesLooped
		if {$numTimesLooped >= $numUntilUpdate} {
			ctext::update
			set numTimesLooped 0
		}
	}

	foreach {ichar tagInfo} [array get highlightSpecialCharsAr] {
		set si $start
		foreach {tagClass color} $tagInfo break

		while 1 {
			set res [$twin search -- $ichar $si $end]
			if {"" == $res} {
				break
			}
			set wordEnd [$twin index "$res + 1 chars"]

			$twin tag add $tagClass $res $wordEnd
			$twin tag configure $tagClass -foreground $color
			set si $wordEnd

			incr numTimesLooped
			if {$numTimesLooped >= $numUntilUpdate} {
				ctext::update
				set numTimesLooped 0
			}
		}
	}

	foreach {tagClass tagInfo} [array get highlightRegexpAr] {
		set si $start
		foreach {re color} $tagInfo break
		while 1 {
			set res [$twin search -count length -regexp -- $re $si $end]
			if {"" == $res} {
				break
			}

			set wordEnd [$twin index "$res + $length chars"]
			$twin tag add $tagClass $res $wordEnd
			$twin tag configure $tagClass -foreground $color
			set si $wordEnd

			incr numTimesLooped
			if {$numTimesLooped >= $numUntilUpdate} {
				ctext::update
				set numTimesLooped 0
			}
		}
	}
}

proc ctext::linemapToggleMark {win y} {
	ctext::getAr $win config configAr

	if {!$configAr(-linemap_markable)} {
		return
	}

	set markChar [$win.l index @0,$y]
	set lineSelected [lindex [split $markChar .] 0]
	set line [$win.l get $lineSelected.0 $lineSelected.end]

	if {$line == ""} {
		return
	}

	ctext::getAr $win linemap linemapAr

	if {[info exists linemapAr($line)] == 1} {
		#It's already marked, so unmark it.
		array unset linemapAr $line
		ctext::linemapUpdate $win
		set type unmarked
	} else {
		#This means that the line isn't toggled, so toggle it.
		array set linemapAr [list $line {}]
		$win.l tag add lmark $markChar [$win.l index "$markChar lineend"]
		$win.l tag configure lmark -foreground $configAr(-linemap_select_fg) \
-background $configAr(-linemap_select_bg)
		set type marked
	}

	if {[string length $configAr(-linemap_mark_command)]} {
		uplevel #0 [linsert $configAr(-linemap_mark_command) end $win $type $line]
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

	ctext::getAr $win linemap linemapAr

	$win.l delete 1.0 end
	set lastLine {}
	foreach line $lineList {
		if {$line == $lastLine} {
			$win.l insert end "\n"
		} else {
			if {[info exists linemapAr($line)]} {
				$win.l insert end "$line\n" lmark
			} else {
				$win.l insert end "$line\n"
			}
		}
		set lastLine $line
	}
}

proc ctext::modified {win value} {
	ctext::getAr $win config ar
	set ar(modified) $value
	event generate $win <<Modified>>
	return $value
}
### Added in the ASED version 3.0 of ctext
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
### End of additions
