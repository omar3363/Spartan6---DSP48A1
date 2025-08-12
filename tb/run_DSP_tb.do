# Create library
vlib work

# Compile the Verilog file
vlog Spartan_6_tb.v

# Start the simulation with full visibility
vsim -voptargs=+acc Spartan_6_tb

# Add specific waves for debugging

add wave CLK_tb
add wave *RST*_tb

add wave OPMODE_tb
add wave A_tb
add wave B_tb
add wave C_tb
add wave D_tb
add wave PCIN_tb

add wave BCOUT_DUT
add wave M_DUT
add wave P_DUT
add wave PCOUT_DUT
add wave CARRYOUT_DUT

add wave BCOUT_Expected
add wave M_Expected
add wave P_Expected
add wave CARRYOUT_Expected

# Run the simulation until it finishes
run -all

# uncomment to automatically close the simulation
# quit -sim