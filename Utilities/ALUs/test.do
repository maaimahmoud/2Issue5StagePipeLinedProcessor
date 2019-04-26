force -freeze sim:/alus8x16/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/alus8x16/m(0) 16'h0180 0
force -freeze sim:/alus8x16/q(0) 8'b01100000 0
force -freeze sim:/alus8x16/rst 1 0
force -freeze sim:/alus8x16/start 0 0
run
force -freeze sim:/alus8x16/rst 0 0
run
force -freeze sim:/alus8x16/start 1 0
run
run
run
run
run
run
run
run
force -freeze sim:/alus8x16/start 0 0
run
force -freeze sim:/alus8x16/start 1 0
run