## This area group constraint helps to place a RO in a particular area of FPGA
## Make sure you dont place in illegal area 
# INST "RO_GENIE*" AREA_GROUP = RO_PLACEMENT1;
# AREA_GROUP "RO_PLACEMENT1" RANGE = SLICE_X58Y0:SLICE_X65Y10;

## demander a mariam
create_pblock ring_oscillator_block
resize_pblock ring_oscillator_block -add SLICE_X0Y0:SLICE_X10Y10
add_cells_to_pblock ring_oscillator_block [get_cells RO_PATH_INV*]

set_property LOC SLICE_X0Y0 [get_cells RO_PATH_INV*]

set_property SEVERITY {Warning} [get_drc_checks LUTLP-1]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets <myHier/myNet>]
