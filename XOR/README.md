Directory:

	hope\
                xor_insert.tcl
                Netlist
                Xor

[copy these two folders and the tcl file in hope directory ]


Procedure to run:

1. Copy unlocked bench netlist in the Netlist folder.
2. Execute ./xor_insert.tcl script from hope directory
3. Give netlist name (.bench format) and key as input

Output:
1. Previous unlocked bench netlist is converted to locked bench netlist. The name is ${netlist_name}_final_xor.bench and located in Xor folder.








