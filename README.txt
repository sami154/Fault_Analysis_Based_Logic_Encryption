About the Project:

Logic encryption of an IC with additional gate insertion is a well-known countermeasure against IC piracy, which hides the functionality and the implementation of a design by inserting some additional gates called “key-gates” into the original design. The valid key must be supplied to the encrypted design to exhibit its correct functionality (produce correct outputs). Upon applying a wrong key, the encrypted design will show a wrong functionality (produce wrong outputs). 

The idea of logic encryption where wrong key causes a wrong output is analogous to production of wrong output due to a fault in the design. This technique inserts XOR/XNOR and Mux as key gates for each key bit to encrypt a given design using this analogy.

For XOR/XNOR insertion, a wrong key insertion is considered as a stuck-at-0/stuck-at-1 fault excitation. All wrong keys cannot corrupt the output as they might be blocked for some input patterns which is similar to the fault propagation scenario. Moreover, the effect of one key-gate might mask the effect of other key-gates which is same as fault masking. Therefore, “Fault Impact” metric has been proposed in [1] to determine the location in the circuit to insert XOR/XNOR key-gate where, if a fault occurs, it can affect most of the outputs for most of the input patterns. At the location with the highest fault impact, an invalid key will likely have the most impact on the outputs.

For Mux-based encryption, fault propagation and fault-masking are similar to the XOR-based encryption. However, the effect of fault activation is different since MUX-insertion cannot always guarantee fault activation. To select the location to insert MUX, “Contradiction Metric” is calculated. Therefore, the wires with highest fault impact and contradiction metric are selected as true and false wire of the inserted MUX, respectively.

For more information, please read the paper [1] in the reference section.

There are two tool has been developed.

1. XOR key gate insertion tool -- Readme file on how to run the tool is located inside XOR folder.
2. MUX key gate insertion tool -- Readme file on how to run the tool is located inside MUX folder.


Reference:

1. J. Rajendran et al., "Fault Analysis-Based Logic Encryption," in IEEE Transactions on Computers, vol. 64, no. 2, pp. 410-424, Feb. 2015, doi: 10.1109/TC.2013.193.
