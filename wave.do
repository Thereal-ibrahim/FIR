# Waveform setup for FIR testbench
onerror {resume}

add wave -divider "FIR Signals"
add wave -radix signed /FIR_tb/inp_sig
add wave -radix signed /FIR_tb/out_sig
add wave /FIR_tb/CLK
add wave /FIR_tb/n_RST

# Optional: show the DUT instance signals too
add wave -divider "DUT Internal"
add wave -radix signed /FIR_tb/dut/comb_accum
add wave -radix signed /FIR_tb/dut/out_sig_reg

TreeUpdate [SetDefaultTree]
WaveRestoreZoom {0 ns} {200 ns}
