vsim -gui work.MotherBoard
add wave sim:/MotherBoard/*

force -freeze sim:/motherboard/clk 0 0, 1 {50 ps} -r 100

mem load -i ./RAMs/InstructionMemory.mem -format mti /motherboard/fetchMap/instructionMemMap/Ram
mem load -i ./RAMs/DataMemory.mem -format mti /motherboard/MemoryMap/dataMemoryMap/Ram

force -freeze sim:/motherboard/reset 1 0

run

force -freeze sim:/motherboard/reset 0 0

mem load -filltype value -filldata {0000000000000011 } -fillradix symbolic /motherboard/DecodeMap/myRegisters(1)
mem load -filltype value -filldata {0000000000000101 } -fillradix symbolic /motherboard/DecodeMap/myRegisters(3)

force -freeze sim:/motherboard/INTERRUPT 0 0
force -freeze sim:/motherboard/inPort 0000000000000000 0

# Control Unit

#force -freeze sim:/motherboard/fetchMap/pcInMuxMap/selectionLines 000 0

#force -freeze sim:/motherboard/execute_Mux1Selector 000 0
#force -freeze sim:/motherboard/execute_Mux2Selector 000 0
#force -freeze sim:/motherboard/execute_Mux3Selector 000 0
#force -freeze sim:/motherboard/execute_Mux4Selector 000 0
#force -freeze sim:/motherboard/mux1WBSelectorInIDEX 00 0
#force -freeze sim:/motherboard/mux2WBSelectorInIDEX 00 0

#run

####################################
# Hazard detection unit


force -freeze sim:/motherboard/fetchDecode_En 1 0
run

force -freeze sim:/motherboard/pcEn 1 0
#force -freeze sim:/motherboard/fetchDecode_En 0 0

force -freeze sim:/motherboard/decodeExecute_En1 1 0
force -freeze sim:/motherboard/decodeExecute_En2 1 0
run
#force -freeze sim:/motherboard/decodeExecute_En1 0 0
#force -freeze sim:/motherboard/decodeExecute_En2 0 0

force -freeze sim:/motherboard/executeMem_En1 1 0
force -freeze sim:/motherboard/executeMem_En2 1 0
run
#force -freeze sim:/motherboard/executeMem_En1 0 0
#force -freeze sim:/motherboard/executeMem_En2 0 0

force -freeze sim:/motherboard/memWB_En1 1 0
force -freeze sim:/motherboard/memWB_En2 1 0
run

#force -freeze sim:/motherboard/memWB_En1 0 0
#force -freeze sim:/motherboard/memWB_En2 0 0

run