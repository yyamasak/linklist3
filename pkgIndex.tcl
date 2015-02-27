package ifneeded linklist 3.0 [format {
	set dir "%s"
	source [file join $dir linklist.tcl]
	source [file join $dir prio_queue.tcl]
	source [file join $dir sized_queue.tcl]
} $dir]
