vsim work.controlunit
# vsim work.controlunit 
# Start time: 13:28:01 on May 01,2019
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.math_real(body)
# Loading work.constants
# Loading work.controlunit(controlunitarch)
add wave -position insertpoint  \
sim:/controlunit/opCode \
sim:/controlunit/Execute \
sim:/controlunit/readFromMemory \
sim:/controlunit/writeToMemory \
sim:/controlunit/WB \
sim:/controlunit/incSP \
sim:/controlunit/decSP \
sim:/controlunit/loadImmediate \
sim:/controlunit/wbMuxSelector \
sim:/controlunit/interrupt \
sim:/controlunit/reset \
sim:/controlunit/insertNOP \
sim:/controlunit/pcSelector \
sim:/controlunit/opMode
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: Loai Ali  Hostname: DESKTOP-BNOC5EH  ProcessID: 2876
#           Attempting to use alternate WLF file "./wlftt25t0q".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlftt25t0q
force -freeze sim:/controlunit/opCode 00000 0
force -freeze sim:/controlunit/interrupt 0 0
force -freeze sim:/controlunit/reset 0 0
force -freeze sim:/controlunit/insertNOP 0 0
run
force -freeze sim:/controlunit/opCode 00001 0
run
force -freeze sim:/controlunit/opCode 00010 0
run
force -freeze sim:/controlunit/opCode 00011 0
run
force -freeze sim:/controlunit/opCode 00100 0
run
force -freeze sim:/controlunit/opCode 00101 0
run
force -freeze sim:/controlunit/opCode 00110 0
run
force -freeze sim:/controlunit/opCode 00111 0
run
force -freeze sim:/controlunit/opCode 01000 0
run
force -freeze sim:/controlunit/opCode 01001 0
run
force -freeze sim:/controlunit/opCode 01010 0
run
force -freeze sim:/controlunit/opCode 01011 0
run
force -freeze sim:/controlunit/opCode 01100 0
run
force -freeze sim:/controlunit/opCode 01101 0
run
force -freeze sim:/controlunit/opCode 01110 0
run
force -freeze sim:/controlunit/opCode 10000 0
run
force -freeze sim:/controlunit/opCode 10001 0
run
force -freeze sim:/controlunit/opCode 10010 0
run
force -freeze sim:/controlunit/opCode 10011 0
run
force -freeze sim:/controlunit/opCode 10100 0
run
force -freeze sim:/controlunit/opCode 11000 0
run
force -freeze sim:/controlunit/opCode 11001 0
run
force -freeze sim:/controlunit/opCode 11010 0
run
force -freeze sim:/controlunit/opCode 11011 0
run
force -freeze sim:/controlunit/opCode 11100 0
run
force -freeze sim:/controlunit/opCode 11101 0
run
force -freeze sim:/controlunit/opCode 11110 0
run

