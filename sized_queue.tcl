package require linklist

if {![Object isclass LinkList::SizedQueue]} {
Class LinkList::SizedQueue -superclass LinkList::Container -parameter {max}
}

LinkList::SizedQueue instproc reduce {} {
	while {[my size] > [my max]} {
		set e [my shift]
		$e destroy
	}
}

LinkList::SizedQueue instproc add {element} {
	next
	my reduce
	return $element
}

LinkList::SizedQueue proc test {} {
	Class Thread -instmixin LinkList::Element
	
	set q [LinkList::SizedQueue new -max 5]
	
	$q push [Thread new]
	$q push [Thread new]
	$q push [Thread new]
	$q push [Thread new]
	$q push [Thread new]
	$q push [Thread new]
	$q push [Thread new]
	
	puts list=[$q list]
	foreach m [$q list] {
		puts [$m status]
	}
	
	set isolates [$q destroy]
	puts isolates=$isolates
	
	foreach m $isolates {
		puts [$m status]
	}
	
	set q [LinkList::SizedQueue new -max 3]
	foreach e $isolates {
		$q push $e
	}
	puts list=[$q list]
	foreach m [$q list] {
		puts [$m status]
	}
	
 	set t [$q at 1]
 	puts "$t destroy"
 	$t destroy
 	
	puts list=[$q list]
	foreach m [$q list] {
		puts [$m status]
	}
	
	puts "Threads = [Thread info instances]"
	foreach m [$q list] {
		puts [$m destroy]
	}
	puts "Threads = [Thread info instances]"
}
