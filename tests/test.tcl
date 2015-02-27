package require -exact linklist 3.0

Class ThreadManager -instmixin {LinkList::Container}
Class Thread -instmixin {LinkList::Element}

proc log {msg} {
	puts $msg
}

proc test {} {
	set manager [ThreadManager new]

	log push=[$manager push [Thread new]]; # => new element
	log push=[$manager push [Thread new]]
	log push=[$manager push [Thread new]]
	log unshift=[$manager unshift [Thread new]]
	log unshift=[$manager unshift [Thread new]]
	log unshift=[$manager unshift [Thread new]]

	log list=[$manager list]; # => elements

	log [set ta [$manager at end]]
	log new=[set tb [Thread new]]
	log append=[$ta append $tb]
	log new=[set tc [Thread new]]
	log prepend=[$ta prepend $tc]

	log list=[$manager list]; # => elements
	log first=[$manager first]
	log last=[$manager last]

	log delete=[$manager delete $tc]

	log shift=[[$manager shift] destroy]
	log shift=[[$manager shift] destroy]
	log shift=[[$manager shift] destroy]

	log list=[$manager list]; # => elements
	log first=[$manager first]
	log last=[$manager last]

	log pop=[[$manager pop] destroy]
	log pop=[[$manager pop] destroy]
	log pop=[[$manager pop] destroy]

	log list=[$manager list]; # => elements
	log first=[$manager first]
	log last=[$manager last]

	log pop=[[$manager pop] destroy]

	log list=[$manager list]; # => {}
	log first=[$manager first]
	log last=[$manager last]

	log pop=[$manager pop]; # => {}

	log push=[$manager push [Thread new]]
	log push=[$manager push [Thread new]]
	log push=[$manager push [Thread new]]
	log unshift=[$manager unshift [Thread new]]
	log unshift=[$manager unshift [Thread new]]
	
	log unshift=[set td [$manager unshift [Thread new]]]
	log destroy=[$td destroy]

	log last=[$manager last]
	log list=[$manager list]
	log size=[$manager size]
	log destroy=[set isolates [$manager destroy]]

	log isolates=$isolates
	foreach iso $isolates {
		$iso destroy
	}
	
	set manager [ThreadManager new]
	log "push 10000 times=[time {$manager push [Thread new]} 10000]"
	log "size=[llength [$manager list]]"
	log "cleanup=[$manager clear]"
	log "destroy=[$manager destroy]"
}; # proc test

test
log [time {test} 3]

puts [llength [Thread info children]]
