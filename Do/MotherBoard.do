vsim -gui work.MotherBoard
add wave sim:/MotherBoard/*
force -freeze sim:/motherboard/clk 0 0, 1 {50 ps} -r 100

mem load -i ./RAMs/InstructionMemory.mem -format mti /motherboard/fetchMap/instructionMemMap/Ram
mem load -i ./RAMs/DataMemory.mem -format mti /motherboard/MemoryMap/dataMemoryMap/Ram

force -freeze sim:/motherboard/reset 1 0

run

force -freeze sim:/motherboard/reset 0 0

run

mem load -filltype value -filldata {0000000000000011 } -fillradix symbolic /motherboard/DecodeMap/myRegisters(0)

run




force -freeze sim:/motherboard/fetchMap/pcInMuxMap/selectionLines 000 0

force -freeze sim:/motherboard/fetchDecodeBufferEn 1 0