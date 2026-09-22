# Compile and run the FIR testbench
vlib work
vlog -work work -sv FIR.sv FIR_tb.sv
vsim -t 1ps -novopt work.FIR_tb

# Load waveform config
 do wave.do

# Run the simulation
run -all

# Exit ModelSim/Questa
quit -f
