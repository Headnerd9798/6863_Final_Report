include report.itcl
include helper.itcl

set proj_dir [get_proj_dir]
set block_db $proj_dir/db
set block_report $proj_dir/block_report
set hier_report $proj_dir/hier_report

## Tcl script for the block level
run_block

check_cdc -export -database -file $block_db -force

violations_count $block_report
clear -all

## Tcl script for the SoC level

run_hier $block_db
hier_report $hier_report "$block_report ip"
