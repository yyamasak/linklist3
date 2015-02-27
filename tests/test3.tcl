package require -exact linklist 3.0

Class ListContainer -instmixin {LinkList::Container}
Class ListElement -instmixin {LinkList::Element}

proc make_list {size} {
	set q [ListContainer new]
	for {set i 0} {$i < $size} {incr i} {
		$q push [ListElement new]
	}
	return $q
}

proc list_all {q} {
	puts "list_all"
	for {set e [$q first]} {$e ne {}} {set e [$e next_p]} {
		puts "e = $e"
	}
	puts $e
}

proc list_from {q idx} {
	puts "list_from $idx, ce = [set ce [$q at $idx]]"
	for {set e $ce; set init 0} {$init ? $e ne $ce : [incr init]} {set e [$e get_next_circulary]} {
		puts "e = $e"
	}
	puts $e
}

set size 4
set q [make_list $size]

list_all $q

for {set i 0} {$i < $size} {incr i} {
	list_from $q $i
}

list_from $q end
# list_from $q end-1

$q destroy
