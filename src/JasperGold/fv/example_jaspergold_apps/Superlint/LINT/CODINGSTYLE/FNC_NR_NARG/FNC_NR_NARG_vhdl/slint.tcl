config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FNC_NR_NARG}
analyze -vhdl2k FNC_NR_NARG.vhd  
elaborate
clock -none
reset -none
check_superlint -extract
