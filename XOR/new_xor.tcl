proc xor_eq {input1 input2 num} {
	
	
	set input2_not "xor_in2_$num\_not_ = NOT($input2)"
	set input1_not "xor_in1_$num\_not_ = NOT($input1)"

	set line0_0 "xor_$num\_line0_0_ = AND($input1,xor_in2_$num\_not_)"
	set line0_2 "xor_$num\_line0_2_ = NOT(xor_$num\_line0_0_)"
	
	

	set line1_0 "xor_$num\_line1_0_ = AND(xor_in1_$num\_not_,$input2)"
	set line1_2 "xor_$num\_line1_2_ = NOT(xor_$num\_line1_0_)"
	
		
	set line01_1 "xor_$num\_line01_1_ = AND(xor_$num\_line0_2_,xor_$num\_line1_2_)"
	set line01_2 "xor_$input2\_out_ = NOT(xor_$num\_line01_1_)"
	set output_net "xor_$input2\_out_"
	set full_xor "$input2_not\n$input1_not\n$line0_0\n$line0_2\n$line1_0\n$line1_2\n$line01_1\n$line01_2"
	
	return [list [list $full_xor] $output_net]
	

}

proc new_bench {filename net keyinput num} {
	set file1 [open $filename r]
	set file2 [open locked_xor.bench w]
	while {[gets $file1 line] >= 0} {
		if { [string match "*=*$net*" $line]} {
			set new_xor [xor_eq $net $keyinput $num]
			set new_net [lindex $new_xor 1]
			#puts $net
			set gate_sub [regsub "$net" $line $new_net]
			# puts $file2 "# $net is replaced with $new_net"
			puts $file2 $gate_sub
		} else {
			#puts $line
			puts $file2 $line
		}

	}
	set replaced_xor [xor_eq $net $keyinput $num]
	set new_xor_comm [lindex $replaced_xor 0]
	#puts $file2 "# new xor gate insertion at $net"
	puts $file2 "INPUT($keyinput)"
	foreach i $new_xor_comm {

		puts $file2 $i
	}
	
	close $file1
	close $file2
	exec touch $filename
	
	set new_file locked_xor.bench
	exec rm $filename
	exec mv $new_file $filename
	
	
	return 1
}

 
