vsim -gui work.MotherBoard
add wave sim:/MotherBoard/*

add wave -position insertpoint sim:/motherboard/hazardMap/*

add wave -position insertpoint  \
sim:/motherboard/DecodeMap/myRegisters

force -freeze sim:/motherboard/clk 0 0, 1 {50 ps} -r 100

mem load -i ./RAMs/Branch.mem -format mti /motherboard/fetchMap/instructionMemMap/Ram
mem load -i ./RAMs/DataMemory.mem -format mti /motherboard/MemoryMap/dataMemoryMap/Ram


force -freeze sim:/motherboard/reset 1 0


force -freeze sim:/motherboard/INTERRUPT 0 0
force -freeze sim:/motherboard/inPort 0000000000000000 0


run
force -freeze sim:/motherboard/reset 0 0
run
run
force -freeze sim:/motherboard/inPort 0000000000110000 0
run
force -freeze sim:/motherboard/inPort 0000000001010000 0
run
force -freeze sim:/motherboard/inPort 0000000100000000 0
run
force -freeze sim:/motherboard/inPort 0000001100000000 0
run
force -freeze sim:/motherboard/inPort 0000001000000000 0
