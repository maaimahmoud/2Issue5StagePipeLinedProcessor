restart -f -nolist -nowave -nolog -nobreak -novirtuals -noassertions -nofcovers -noatv
add wave -position end  sim:/hazarddetectionunit/*

# simulate following instructinos

# CASE 1
####################################################################################################
# MOV R5, R6									pip1decode
# MOV R4, R5 									pip2decode
# LDD R2, R1 -- R1 = address(R2)				pip1fetch
# SUB R3, R1									pip2fetch, dependancy from pip1fetch
####################################################################################################


# CASE 2
####################################################################################################
# LDD R5, R6									pip1decode
# MOV R4, R5 									pip2decode
# LDD R6, R1 -- R1 = address(R2)				pip1fetch, dependancy from pip1decode
# SUB R3, R5									pip2fetch
####################################################################################################

# CASE 3
####################################################################################################
# MOV R4, R5									pip1decode
# MOV R5, R6 									pip2decode
# LDD R6, R1 -- R1 = address(R2)				pip1fetch, dependancy from pip2decode but no load
# SUB R3, R5									pip2fetch
####################################################################################################

# CASE 4
####################################################################################################
# MOV R4, R5									pip1decode
# LDD R5, R6 									pip2decode
# LDD R6, R1 -- R1 = address(R2)				pip1fetch, dependancy from pip2decode
# SUB R1, R6									pip2fetch, dependancy from pip2decode, dependancy from pip1fetch
####################################################################################################

# CASE 1
####################################################################################################
force -freeze sim:/hazarddetectionunit/pip1DecodeOp 01000 0
force -freeze sim:/hazarddetectionunit/pip2DecodeOp 01000 0
force -freeze sim:/hazarddetectionunit/pip1FetchOp 10011 0
force -freeze sim:/hazarddetectionunit/pip2fetchOp 01010 0

force -freeze sim:/hazarddetectionunit/pip1DecodeSrc 101 0
force -freeze sim:/hazarddetectionunit/pip2DecodeSrc 100 0
force -freeze sim:/hazarddetectionunit/pip1FetchSrc 010 0
force -freeze sim:/hazarddetectionunit/pip2fetchSrc 011 0

force -freeze sim:/hazarddetectionunit/pip1DecodeDst 110 0
force -freeze sim:/hazarddetectionunit/pip2DecodeDst 101 0
force -freeze sim:/hazarddetectionunit/pip1FetchDst 001 0
force -freeze sim:/hazarddetectionunit/pip2fetchDst 001 0
run
run
####################################################################################################



# CASE 2
####################################################################################################
force -freeze sim:/hazarddetectionunit/pip1DecodeOp 10011 0
force -freeze sim:/hazarddetectionunit/pip2DecodeOp 01000 0
force -freeze sim:/hazarddetectionunit/pip1FetchOp 10011 0
force -freeze sim:/hazarddetectionunit/pip2fetchOp 01010 0

force -freeze sim:/hazarddetectionunit/pip1DecodeSrc 101 0
force -freeze sim:/hazarddetectionunit/pip2DecodeSrc 100 0
force -freeze sim:/hazarddetectionunit/pip1FetchSrc 110 0
force -freeze sim:/hazarddetectionunit/pip2fetchSrc 011 0

force -freeze sim:/hazarddetectionunit/pip1DecodeDst 110 0
force -freeze sim:/hazarddetectionunit/pip2DecodeDst 101 0
force -freeze sim:/hazarddetectionunit/pip1FetchDst 001 0
force -freeze sim:/hazarddetectionunit/pip2fetchDst 101 0
run
run
####################################################################################################


# CASE 3
####################################################################################################
force -freeze sim:/hazarddetectionunit/pip1DecodeOp 01000 0
force -freeze sim:/hazarddetectionunit/pip2DecodeOp 01000 0
force -freeze sim:/hazarddetectionunit/pip1FetchOp 10011 0
force -freeze sim:/hazarddetectionunit/pip2fetchOp 01010 0

force -freeze sim:/hazarddetectionunit/pip1DecodeSrc 100 0
force -freeze sim:/hazarddetectionunit/pip2DecodeSrc 101 0
force -freeze sim:/hazarddetectionunit/pip1FetchSrc 110 0
force -freeze sim:/hazarddetectionunit/pip2fetchSrc 011 0

force -freeze sim:/hazarddetectionunit/pip1DecodeDst 101 0
force -freeze sim:/hazarddetectionunit/pip2DecodeDst 110 0
force -freeze sim:/hazarddetectionunit/pip1FetchDst 001 0
force -freeze sim:/hazarddetectionunit/pip2fetchDst 101 0
run
run
####################################################################################################



# CASE 4
####################################################################################################
force -freeze sim:/hazarddetectionunit/pip1DecodeOp 01000 0
force -freeze sim:/hazarddetectionunit/pip2DecodeOp 10011 0
force -freeze sim:/hazarddetectionunit/pip1FetchOp 10011 0
force -freeze sim:/hazarddetectionunit/pip2fetchOp 01010 0

force -freeze sim:/hazarddetectionunit/pip1DecodeSrc 100 0
force -freeze sim:/hazarddetectionunit/pip2DecodeSrc 101 0
force -freeze sim:/hazarddetectionunit/pip1FetchSrc 110 0
force -freeze sim:/hazarddetectionunit/pip2fetchSrc 001 0

force -freeze sim:/hazarddetectionunit/pip1DecodeDst 101 0
force -freeze sim:/hazarddetectionunit/pip2DecodeDst 110 0
force -freeze sim:/hazarddetectionunit/pip1FetchDst 001 0
force -freeze sim:/hazarddetectionunit/pip2fetchDst 110 0
run
run
####################################################################################################
