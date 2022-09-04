#!/usr/bin/tclsh
#set netlist "c432_syn.bench"
proc hammingDistance {left right} {
    if {[string length $left] != [string length $right]} {
        error "left and right strands must be of equal length"
    }

    set dist 0
    foreach L [split $left ""] R [split $right ""] {
        if {$L ne $R} {
            incr dist

        }
    }
    return $dist
}




proc faultimpact {net_name} {

set fp [open ./Xor/fn_new.txt r]
set file_data [read $fp]
close $fp



set NoOo 0
set NoPo 0
set N1O1 0
set N1P1 0
set x " "
set y " "

#puts $net_name


set data [split $file_data "\n"]
	
	foreach line $data {
		
		if {[regexp "^test" $line myvar] !=0 } {
			#puts "$line"
			regexp  {\s(\w+)$} $line -> a
			#puts "$a"
		}

		if {[regexp $net_name $line myvar] !=0 } {
			if {[regexp {[/.][0]}  $line] != 0} {


				#puts "match"
				#puts $line

			
				regexp  {\s(\w+)$} $line -> b
				#puts "$b"
				if {[hammingDistance $a $b] > 0} {
				
					#puts "$a $b"
					set dist [hammingDistance $a $b]
					set count1 [expr $NoOo + $dist]
					set NoOo $count1
					#incr NoPo
					if {$x!=$a} {
						incr NoPo	
				   	}		
					set x $a

				}

			}
		}
		

		if {[regexp $net_name $line myvar] !=0 } {
			if {[regexp {[/.][1]}  $line] != 0} {


				#puts "match"
				#puts $line

			
				regexp  {\s(\w+)$} $line -> b
				#puts "$b"
				if {[hammingDistance $a $b] > 0} {
				
					#puts "$a $b"
					set dist [hammingDistance $a $b]
					set count1 [expr $N1O1 + $dist]
					set N1O1 $count1
					#incr N1P1
					if {$y!=$a} {
						incr N1P1	
				   	}		
					set y $a

				}

			}
		}

		

	}

#puts $NoOo

#puts $NoPo

#puts $N1O1
#puts $N1P1

set faultimpact1 [expr $NoOo*$NoPo]

#puts "Stuck at 0 faultimpact $faultimpact1"


set faultimpact2 [expr $N1O1*$N1P1]

#puts "Stuck at 1 faultimpact $faultimpact2"


set faultimpact [expr $faultimpact1+$faultimpact2]

#puts "Total faultimpact $faultimpact"

return $faultimpact

}

proc fault_impact_new {netlist} {

set fp [open "./Xor/fn.txt" r]
set file_data [read $fp]
close $fp

set outfile1 [open "./Xor/fn_new.txt" w+]

set data [split $file_data "\n"]

        foreach line $data {

                if {[regexp "^test" $line myvar] !=0 } {
                        puts $outfile1 $line
                 }
                if {[regexp {[*]} $line myvar] !=0 } {
                        puts $outfile1 $line
                 }

        }


close $outfile1



set fp1 [open ./Xor/$netlist r]
set file_data1 [read $fp1]
close $fp1

set data1 [split $file_data1 "\n"]

#source fault_impact.tcl



set outfile [open ./Xor/fault_impact_report.out w+]



foreach line $data1 {
     # for each internal net
	if {[regexp "^new" $line myvar] !=0 } {

		regexp -nocase -line -- {(\S+)\s+} $line -> b
		#puts "$b [faultimpact $b]"
		puts $outfile "$b [faultimpact $b]"
	

 	}
}


close $outfile
}
