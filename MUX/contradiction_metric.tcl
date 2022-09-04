#!/usr/bin/tclsh


#set netlist "c432_syn.bench"


proc contradiction_metric1 {net_name_true net_name_false} {

set fp1 [open "./Mux/switching_prob_report.txt" r]
set file_data1 [read $fp1]
close $fp1

set data1 [split $file_data1 "\n"]

set Pt0 0
set Pt1 0
set Pf0 0
set Pf1 0

	foreach line $data1 {

		if {[regexp $net_name_true $line myvar] != 0 } {
			set Pt1 [lindex [regexp -all -inline {\S+} $line] 2]
			set Pt0 [expr 1 - $Pt1]
	
		}
        	if {([regexp $net_name_true $line myvar] == 0) && ([regexp $net_name_false $line myvar] != 0) } {

                	set Pf1 [lindex [regexp -all -inline {\S+} $line] 2]
			set Pf0 [expr 1 - $Pf1]
        	}
	}


	set contradiction_metric [expr $Pt0*$Pf1+$Pt1*$Pf0]

	return $contradiction_metric
}



proc contradiction_metric {net_name_true netlist} {


#upvar netlist netlist
set fp1 [open "./Mux/$netlist" r]
set file_data1 [read $fp1]
close $fp1

set data1 [split $file_data1 "\n"]


set outfile [open "./Mux/contradiction_metric_report.out" w+]

foreach line $data1 {

if {[regexp "^new" $line myvar] !=0 } {

		regexp -nocase -line -- {(\S+)\s+} $line -> b
#		puts "$b [faultimpact $b]"
		puts $outfile "$b [contradiction_metric1 $net_name_true $b]"
	

 	}
}


close $outfile
}
