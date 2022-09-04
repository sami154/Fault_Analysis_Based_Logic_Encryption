#set search_path [list ../SAED_EDK90nm/synopsys/]
#set target_library [list saed90nm_typ.db]
#set link_library [list saed90nm_typ.db]
##################################################################



########### Set up working directory  ###########################

define_design_lib work -path ./Mux/work

#################################################################


########### Read Verilog or VHDL files  ###########################
analyze -format verilog  ./Mux/locked_netlist.v

#################################################################


########### Read Verilog by Autoread option  ####################

#analyze {/home/UFAD/ndipu/DOSC/RTL/*} -autoread -recursive -format verilog -top DOSC

#################################################################



set top "locked_netlist"
elaborate -lib work $top 
current_design $top

report_power -net -analysis_effort high -nosplit -sort_mode net_toggle_rate -flat > "./Mux/switching_prob_report.txt"

exit


