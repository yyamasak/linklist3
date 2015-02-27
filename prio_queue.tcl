package require linklist

if {![Object isclass LinkList::PrioQueue]} {
Class LinkList::PrioQueue -superclass LinkList::Container -parameter {
	{default_priority 0}
}
}

LinkList::PrioQueue instproc init {} {
	my instvar default_priority priority
	set priority(min) $default_priority
	set priority(max) $default_priority
	next
}

LinkList::PrioQueue instproc update_priority {ep} {
	my instvar priority
	set min $priority(min)
	set max $priority(max)
	for {set e [my first]} {$e ne {}} {set e [$e next_p]} {
		if {$ep < $min} {
			set min $ep
		}
		if {$ep > $max} {
			set max $ep
		}
	}
	if {$min != $priority(min)} {
		set priority(min) $min
	}
	if {$max != $priority(max)} {
		set priority(max) $max
	}
}

LinkList::PrioQueue instproc unlink {element} {
	set ep [$element priority]
	next
	if {$ep == $priority(min) || $ep == $priority(max)} {
		my update_priority $ep
	}
}

LinkList::PrioQueue instproc add {element} {
	my instvar priority
	set ep [$element priority]
	if {$ep < $priority(min) || $ep > $priority(max)} {
		my update_priority $ep
	}
	next
}

# ARGUMENTS:
#  attr: attribute
#  direction: asc/desc
LinkList::PrioQueue instproc sort_by {attr {direction asc}} {
	set es [my list]
	foreach e $es {
		my drop $e
	}
	set es [lsort -command [myproc order_by $attr $direction] $es]
	foreach e $es {
		my push $e
	}
}

LinkList::PrioQueue instproc order_by {attr direction a b} {
	set pa [$a $attr]
	set pb [$b $attr]
	set diff [expr {$pb - $pa}]
	if {$diff != 0} {
		if {$direction eq "asc"} {
			expr {-int(abs($diff)/$diff)}
		} else {
			expr {int(abs($diff)/$diff)}
		}
	} else {
		return 0
	}
}

LinkList::PrioQueue instproc inspect {} {
	for {set e [my first]} {$e ne {}} {set e [$e next_p]} {
		puts "$e value=[$e value] priority=[$e priority]"
	}
}

LinkList::PrioQueue proc test {} {
	Class Record -instmixin {LinkList::Element} -parameter {
		value
		{priority 0}
	}
	
	set q [LinkList::PrioQueue new]
	
	$q push [Record new -value 0 -priority 0]
	$q push [Record new -value 1 -priority 0]
	$q push [Record new -value 2 -priority 1]
	$q push [Record new -value 3 -priority 0]
	$q push [Record new -value 4 -priority 2]
	$q push [Record new -value 5 -priority 0]
	$q push [Record new -value 6 -priority 2]
	$q push [Record new -value 7 -priority 1]
	
	puts "unsorted"
	$q inspect
	
	$q sort_by priority desc
	
	puts "sorted desc"
	$q inspect
	
	$q sort_by priority asc
	
	puts "sorted asc"
	$q inspect
	
	$q clear
	$q destroy
}
