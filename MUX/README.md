**Directory:**

	hope\
		mux_insert_loop_free.tcl
		Netlist
		Mux
**[copy these two folders and the tcl file in hope directory ]**


**Procedure to run:**

1. Copy unlocked bench netlist in the Netlist folder.
2. Execute ./mux_insert_loop_free.tcl script from hope directory
3. Give netlist name (.bench format) and key as input 

**Output:**
1. Previous unlocked bench netlist is converted to locked bench netlist. The name is ${netlist_name}_final_mux.bench and located in Mux folder.


