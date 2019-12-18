config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {OPR_NR_UCMP}
analyze -vhdl2k OPR_NR_UCMP.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
