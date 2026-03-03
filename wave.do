onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_lab4/clk
add wave -noupdate /testbench_lab4/resetn
add wave -noupdate /testbench_lab4/master_load_enable
add wave -noupdate /testbench_lab4/inValid
add wave -noupdate /testbench_lab4/outReady
add wave -noupdate /testbench_lab4/extIn
add wave -noupdate /testbench_lab4/inReady
add wave -noupdate /testbench_lab4/RinReady
add wave -noupdate /testbench_lab4/outValid
add wave -noupdate /testbench_lab4/ROutValid
add wave -noupdate /testbench_lab4/extOut
add wave -noupdate /testbench_lab4/RextOut
add wave -noupdate /testbench_lab4/pc2seg
add wave -noupdate /testbench_lab4/imDataOut2seg
add wave -noupdate /testbench_lab4/dmDataOut2seg
add wave -noupdate /testbench_lab4/aluOut2seg
add wave -noupdate /testbench_lab4/acc2seg
add wave -noupdate /testbench_lab4/busOut2seg
add wave -noupdate /testbench_lab4/Rpc2seg
add wave -noupdate /testbench_lab4/RimDataOut2seg
add wave -noupdate /testbench_lab4/RdmDataOut2seg
add wave -noupdate /testbench_lab4/RaluOut2seg
add wave -noupdate /testbench_lab4/Racc2seg
add wave -noupdate /testbench_lab4/RbusOut2seg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {57394 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {105 ns}
