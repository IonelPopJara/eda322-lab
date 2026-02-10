add wave *
force clk 0 0, 1 50ns -repeat 100ns
force rstn 0 0ns
force en 0 0ns
force d "11110000" 0ns

force rstn 1 100ns
force en 1 100ns

force d "00001111" 200ns

force rstn 0 400ns
run 500ns