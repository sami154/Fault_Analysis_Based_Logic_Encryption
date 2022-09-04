#!/usr/bin/tclsh
#set netlist c432_syn.bench
puts "Input Netlist "
set netlist [gets stdin]


puts "Input key "
set key [gets stdin]

cd ../../abc-master/
exec cp ../hope_src/hope/Netlist/$netlist .
exec ./abc -c "read_bench $netlist; fraig;  write_bench -l $netlist"
exec cp ./$netlist ../hope_src/hope/Xor/.
cd ../hope_src/hope/


#set key "0011101110"

#exec cp ./Netlist/$netlist ./Xor/.
set each_key [split $key {}]

set keysize [llength $each_key]

set net_num 100000
for {set i 0} {$i < $keysize} {incr i} {
	exec ./hope -F ./Xor/fn.txt -r 1000 ./Xor/$netlist > ./Xor/sum.out
	source ./Xor/fault_impact_new.tcl
	fault_impact_new $netlist
	 exec sort -g -r -k 2 ./Xor/fault_impact_report.out > ./Xor/fault_impact_report_sorted.out
	set file1 [open ./Xor/fault_impact_report_sorted.out r]
	while {[gets $file1 line] >= 0} {
		regexp {^(\w+)} $line -> net_name
		puts " Maximum Fault Impact net: $net_name"
		break
	}
	close $file1
	source ./Xor/new_xor.tcl
	new_bench ./Xor/$netlist $net_name keyinput_$i $net_num
	set net_num [expr $net_num+1]
}

source ./Xor/mod.tcl
mod $netlist $key
puts "Locked Netlist is Generated"
