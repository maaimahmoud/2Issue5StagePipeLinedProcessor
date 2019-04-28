vsim work.controlunit
# vsim work.controlunit 
# Start time: 14:56:48 on Apr 28,2019
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
sim:/controlunit/Branch \
sim:/controlunit/enableOut \
sim:/controlunit/incSP \
sim:/controlunit/decSP \
sim:/controlunit/loadImmediate \
sim:/controlunit/opMode
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: Loai Ali  Hostname: DESKTOP-BNOC5EH  ProcessID: 2876
#           Attempting to use alternate WLF file "./wlftcjg70r".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlftcjg70r
force -freeze sim:/controlunit/opCode 01000 0
run
force -freeze sim:/controlunit/opCode 00000 0
run
force -freeze sim:/controlunit/opCode 00010 0
run
force -freeze sim:/controlunit/opCode 00100 0
run


force -freeze sim:/controlunit/opCode 00110 0
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
force -freeze sim:/controlunit/opCode 11011 0
run
force -freeze sim:/controlunit/opCode 11100 0
run


