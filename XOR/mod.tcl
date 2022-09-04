#!/usr/bin/tclsh
proc mod {netlist key} {
#set netlist c432_syn.bench
set filename_r "./Xor/$netlist"
set top [lindex [split $netlist .] 0]
set filename_w "./Xor/$top\_final_xor.bench"


#set key "0011101110"
set each_key [split $key {}]
set ind [lsearch -all $each_key 1]
set net_mod {}
foreach i $ind {
	lappend net_mod "xor_keyinput_$i\_out_"
		
	}
puts $net_mod

set file3 [open $filename_r r]
set file4 [open $filename_w w]
while {[gets $file3 line] >= 0} {
	
		foreach i $net_mod {
			if {[string match "$i*" $line]} { 
				puts $line
				
				#puts $file4 "$i\xnor_1 = NOT($i)"
				#puts $file4 "$i\xnor_2 = NOT($i\xnor_1)"
				puts $file4 "$i\xnor_1 = NOT($i)"
				
			} 
		
			if {[string match "*=*$i*" $line]} {
				set new_net_2 "$i\xnor_1"
				set net_sub [regsub "$i" $line $new_net_2]
				set line $net_sub
				
			} 
			
			
		}	
	
puts $file4 $line
}
close $file3
close $file4

}
#cd ../../abc-master/
#exec cp ../hope_src/hope/Xor/$top\_final_xor.bench .
#exec ./abc -c "read_bench $top\_final_xor.bench; write_verilog locked_netlist_xor.v"
#exec cp ./locked_netlist_xor.v ../hope_src/hope/Xor/.
#cd ../hope_src/hope/Xor

