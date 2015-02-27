package require -exact linklist 3.0

Class ListContainer -instmixin {LinkList::Container}
Class ListElement -instmixin {LinkList::Element}

proc test_linklist {size} {
	set container [ListContainer new]
	for {set i 0} {$i < $size} {incr i} {
		$container push [ListElement new]
	}
	foreach e [$container rlist] {
		$container delete $e
	}
	return {}
}

proc test_nativelist {size} {
	set l {}
	for {set i 0} {$i < $size} {incr i} {
		lappend l $i
	}
	for {set i 0} {$i < $size} {incr i} {
		set l [lreplace $l end end]
	}
	return {}
}

foreach size {1000 10000 15000 20000 30000} {
	puts "size=$size"
	puts "linklist [time {test_linklist $size} 2]"
	puts "nativelist [time {test_nativelist $size} 2]"
	puts ""
}
