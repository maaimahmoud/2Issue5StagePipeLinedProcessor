vsim -gui work.MotherBoard
add wave sim:/MotherBoard/*

force -freeze sim:/motherboard/clk 0 0, 1 {50 ps} -r 100

mem load -i ./RAMs/InstructionMemory.mem -format mti /motherboard/fetchMap/instructionMemMap/Ram
mem load -i ./RAMs/DataMemory.mem -format mti /motherboard/MemoryMap/dataMemoryMap/Ram


force -freeze sim:/motherboard/reset 1 0


force -freeze sim:/motherboard/INTERRUPT 0 0
force -freeze sim:/motherboard/inPort 0000000000000000 0


run
force -freeze sim:/motherboard/reset 0 0
#force -freeze sim:/motherboard/inPort 0000000000000101 0
#run
#force -freeze sim:/motherboard/inPort 0000000000010011 0
#run
#force -freeze sim:/motherboard/inPort 1111111111111111 0
#run
#force -freeze sim:/motherboard/inPort 1111001100100000 0
#run
force -freeze sim:/motherboard/inPort 0000000000000101 0

run
run
run

force -freeze sim:/motherboard/inPort 0000000000010000 0

run