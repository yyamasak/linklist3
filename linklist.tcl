package require XOTcl
namespace import xotcl::*

namespace eval LinkList {}

Class LinkList::Container

LinkList::Container instproc init {} {
	my set first {}
	my set last {}
	my set size 0
	next
}

LinkList::Container instproc destroy {} {
	set es [my list]
	foreach e $es {
		my drop $e
	}
	next
	return $es
}

LinkList::Container instproc clear {} {
	set es [my list]
	foreach e $es {
		$e destroy
	}
	return {}
}

LinkList::Container instproc first {} {
	my instvar first
	return $first
}

LinkList::Container instproc last {} {
	my instvar last
	return $last
}

LinkList::Container instproc size {} {
	my instvar size
	return $size
}

LinkList::Container instproc unlink {element} {
	my instvar size first last
	
	if {![Object isobject $element]} {return -1}
	if {[$element container] != [self]} {return -1}
	
	set prev [$element prev_p]
	set next [$element next_p]
	
	$element prev_p {}
	$element next_p {}
	$element container {}
	
	if {$prev eq {}} {
		set first $next
	} else {
		$prev next_p $next
	}
	if {$next eq {}} {
		set last $prev
	} else {
		$next prev_p $prev
	}
	
	incr size -1
}

# private
LinkList::Container instproc add {element} {
	my instvar size first last
	if {[$element next_p] == $first} {
		set first $element
	}
	if {[$element prev_p] == $last} {
		set last $element
	}
	$element container [self]
	incr size
	return $element
}

LinkList::Container instproc scan {key value} {
	for {set e [my first]} {$e != {}} {set e [$e next_p]} {
		if {[$e $key] == $value} {return $e}
	}
}

LinkList::Container instproc at {index} {
	if {$index == "end"} {return [my last]}
	if {$index < 0 || [my size] <= $index} {return {}}
	set i 0
	for {set e [my first]} {$e != {}} {set e [$e next_p]} {
		if {$i == $index} {return $e}
		incr i
	}
	return {}; # not found
}

LinkList::Container instproc list {} {
	set es {}
	for {set e [my first]} {$e != {}} {set e [$e next_p]} {
		lappend es $e
	}
	return $es
}

LinkList::Container instproc rlist {} {
	set es {}
	for {set e [my last]} {$e != {}} {set e [$e prev_p]} {
		lappend es $e
	}
	return $es
}

LinkList::Container instproc index {element} {
	set i 0
	for {set e [my first]} {$e != {}} {set e [$e next_p]} {
		if {$e == $element} {return $i}
		incr i
	}
	return -1; # not found
}

LinkList::Container instproc pop {} {
	set last [my last]
	my drop $last
}

LinkList::Container instproc push {element} {
	set last [my last]
	if {$last == {}} {
		my add $element
	} else {
		$last append $element
	}
	return $element
}

LinkList::Container instproc shift {} {
	my drop [my first]
}

LinkList::Container instproc unshift {element} {
	set first [my first]
	if {$first == {}} {
		my add $element
	} else {
		$first prepend $element
	}
	return $element
}

LinkList::Container instproc drop {element} {
	if {[my unlink $element] >= 0} {
		return $element
	}
}

LinkList::Container instproc delete {element} {
	if {![Object isobject $element]} {
		$element destroy
	}
}

# InstMixin this class into element class to use container
Class LinkList::Element -parameter {
	{prev_p {}}
	{next_p {}}
	{container {}}
}

LinkList::Element instproc destroy {} {
	my drop
	next
	return [self]
}

LinkList::Element instproc drop {} {
	if {[my container] != {}} {
		[my container] drop [self]
	}
}

LinkList::Element instproc index {} {
	if {[my container] != {}} {
		[my container] index [self]
	}
}

LinkList::Element instproc append {element} {
	if {[my container] != {}} {
		$element prev_p [self]
		$element next_p [my next_p]
		if {[my next_p] != {}} {
			[my next_p] prev_p $element
		}
		my next_p $element
		[my container] add $element
	}
}

LinkList::Element instproc prepend {element} {
	if {[my container] != {}} {
		$element prev_p [my prev_p]
		$element next_p [self]
		if {[my prev_p] != {}} {
			[my prev_p] next_p $element
		}
		my prev_p $element
		[my container] add $element
	}
}

LinkList::Element instproc get_next_circulary {} {
	if {[my container] != {}} {
		if {[my next_p] != {}} {
			my next_p
		} else {
			[my container] first
		}
	}
}

LinkList::Element instproc get_prev_circulary {} {
	if {[my container] != {}} {
		if {[my prev_p] != {}} {
			my prev_p
		} else {
			[my container] last
		}
	}
}

LinkList::Element instproc status {} {
	append stat "  container = [my container]\n"
	append stat "  index     = [my index]\n"
	append stat "  element   = [self]\n"
	append stat "  neighbors = ([my prev_p]) => ([self]) => ([my next_p])\n"
}

package provide linklist 3.0
