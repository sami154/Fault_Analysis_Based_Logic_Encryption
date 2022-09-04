#!/usr/bin/tclsh
#proc mux_insert_loop_free {netlist key} { 
#set netlist "c432_syn.bench"
puts "Input Netlist "
set netlist [gets stdin]

puts "Input key "
set key [gets stdin]

set top [lindex [split $netlist .] 0]

cd ../../abc-master/
exec cp ../hope_src/hope/Netlist/$netlist .
exec ./abc -c "read_bench $netlist; fraig;  write_bench -l $netlist"
exec cp ./$netlist ../hope_src/hope/Mux/.
cd ../hope_src/hope/

#exec cp ./Netlist/$netlist ./Mux/.

#set key "0011000101"
set each_key [split $key {}]
set net_num 100000
set j 0
set filename "./Mux/$netlist"

cd ../../abc-master/
exec cp ../hope_src/hope/Netlist/$netlist .
#exec ./abc -c "read_bench c432_syn.bench; write_verilog locked_netlist.v"
exec ./abc -c "read_bench $netlist; write_verilog locked_netlist.v"
exec cp ./locked_netlist.v ../hope_src/hope/Mux/.
cd ../hope_src/hope/

foreach i $each_key {
# write DC compiler code here to generate contradiction_metric_report.out file. 
	exec ./Mux/run_compile.sh &
	exec ./hope -F ./Mux/fn.txt -r 1000 ./Mux/$netlist > ./Mux/mux_sum.out
	source ./Mux/fault_impact_new.tcl
	 fault_impact_new $netlist
	 exec sort -g -r -k 2 ./Mux/fault_impact_report.out > ./Mux/fault_impact_report_sorted.out
	set file1 [open ./Mux/fault_impact_report_sorted.out r]
	while {[gets $file1 line] >= 0} {
		regexp {^(\w+)} $line -> net_true
		puts $net_true
		break
	}
	close $file1
	
	
	source ./Mux/contradiction_metric.tcl
	source ./Mux/new_mux.tcl
	contradiction_metric $net_true $netlist
	
	exec sort -g -r -k 2 ./Mux/contradiction_metric_report.out > ./Mux/contradiction_metric_report_sorted.out
	
	set file2 [open ./Mux/contradiction_metric_report_sorted.out r]
	while {[gets $file2 line] >= 0} {
		regexp {^(\w+)} $line -> net_false
		
		if { $i != 1} {
			new_bench $filename $net_true $net_false keyinput$j $net_num $i
			#puts "$net_false is used for i = 0"
		} else {
			new_bench $filename $net_false $net_true keyinput$j $net_num $i
			#puts "$net_false is used for i = 1"
		}
		cd ../../abc-master/
		exec cp ../hope_src/hope/locked_netlist.bench .
		
		if { [catch {exec ./abc -f ../hope_src/hope/Mux/abc_script.tcl}] == 0} {
			puts "$net_false Success"
			exec cp locked_netlist.v ../hope_src/hope/Mux/.
			cd ../hope_src/hope/
			break
		}
		puts "$net_false creating loop"
		cd ../hope_src/hope/
	}
	close $file2
	exec touch $filename
	
	set new_file locked_netlist.bench
	exec rm $filename
	exec mv $new_file $filename
	exec cp $filename ./Mux/$top\_final_mux.bench
	set net_num [expr $net_num+1]
	set j [expr $j+1]
	
}
#}
puts "Locked Netlist is Generated"
