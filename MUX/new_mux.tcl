

proc mux_eq {input1 input2 sel num} {
	
	
	set in2_not "mux_in2_$num\_not_ = NOT($input2)"
	
	set line0_0 "mux_$num\_line0_0_ = AND(mux_in2_$num\_not_,$sel)"
	set line0_1 "mux_$num\_line0_1_ = NOT(mux_$num\_line0_0_)"
	
	set line1_0 "mux_$num\_line1_0_ = AND(mux_$num\_line0_1_,$input1)"
	set line1_1 "mux_$num\_line1_1_ = NOT(mux_$num\_line1_0_)"

	set line2_0 "mux_$num\_line2_0_ = AND($sel,$input2)"
	set line2_1 "mux_$num\_line2_1_ = NOT(mux_$num\_line2_0_)"
		
	set line01_1 "mux_$num\_line01_0_ = AND(mux_$num\_line2_1_,mux_$num\_line1_1_)"
	set line01_2 "new_$sel\_out_ = NOT(mux_$num\_line01_0_)"
	set output_net "new_$sel\_out_"
	set full_xor "$in2_not\n$line0_0\n$line0_1\n$line1_0\n$line1_1\n$line2_0\n$line2_1\n$line01_1\n$line01_2"
	
	return [list [list $full_xor] $output_net]
	

}

proc new_bench {filename net1 net2 keyinput num i} {
	
	set file1 [open $filename r]
	set file2 [open locked_netlist.bench w]
	while {[gets $file1 line] >= 0} {
		if {$i != 1} {
			if { [string match "*=*$net1*" $line]} {
				set new_mux [mux_eq $net1 $net2 $keyinput $num]
				set new_net [lindex $new_mux 1]
				#puts $net
				set gate_sub [regsub "$net1" $line $new_net]
				# puts $file2 "# $net is replaced with $new_net"
				puts $file2 $gate_sub
			} else {
				#puts $line
				puts $file2 $line
			}
		} else {
			if { [string match "*=*$net2*" $line]} {
				set new_mux [mux_eq $net1 $net2 $keyinput $num]
				set new_net [lindex $new_mux 1]
				#puts $net
				set gate_sub [regsub "$net2" $line $new_net]
				# puts $file2 "# $net is replaced with $new_net"
				puts $file2 $gate_sub
			} else {
				#puts $line
				puts $file2 $line
			}
		}

	}
	set replaced_mux [mux_eq $net1 $net2 $keyinput $num]
	set new_mux_comm [lindex $replaced_mux 0]
	#puts $file2 "# new xor gate insertion at $net"
	puts $file2 "INPUT($keyinput)"
	foreach i $new_mux_comm {

		puts $file2 $i
	}
	
	close $file1
	close $file2
	#exec touch $filename
	
	#set new_file new_file.bench
	#exec rm $filename
	#exec mv $new_file $filename
	
	
	return 1
}
