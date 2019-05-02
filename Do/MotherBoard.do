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

#force -freeze sim:/motherboard/mux1SelectorEX 000 0
#force -freeze sim:/motherboard/mux2SelectorEX 000 0
#force -freeze sim:/motherboard/mux3SelectorEX 000 0
#force -freeze sim:/motherboard/mux4SelectorEX 000 0
#force -freeze sim:/motherboard/mux1WBSelectorInIDEX 00 0
#force -freeze sim:/motherboard/mux2WBSelectorInIDEX 00 0

#run

####################################
# Hazard detection unit


force -freeze sim:/motherboard/fetchDecodeBufferEn 1 0
run

force -freeze sim:/motherboard/pcEn 1 0
#force -freeze sim:/motherboard/fetchDecodeBufferEn 0 0

force -freeze sim:/motherboard/enableRead1IDEX 1 0
force -freeze sim:/motherboard/enableRead2IDEX 1 0
run
#force -freeze sim:/motherboard/enableRead1IDEX 0 0
#force -freeze sim:/motherboard/enableRead2IDEX 0 0

force -freeze sim:/motherboard/ExecuteMemoryBuffer1En 1 0
force -freeze sim:/motherboard/ExecuteMemoryBuffer2En 1 0
run
#force -freeze sim:/motherboard/ExecuteMemoryBuffer1En 0 0
#force -freeze sim:/motherboard/ExecuteMemoryBuffer2En 0 0

force -freeze sim:/motherboard/enableRead1MEMWB 1 0
force -freeze sim:/motherboard/enableRead2MEMWB 1 0
run

#force -freeze sim:/motherboard/enableRead1MEMWB 0 0
#force -freeze sim:/motherboard/enableRead2MEMWB 0 0

run