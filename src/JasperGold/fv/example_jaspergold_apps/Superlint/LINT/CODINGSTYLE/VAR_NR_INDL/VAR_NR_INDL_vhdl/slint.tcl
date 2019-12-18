config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {VAR_NR_INDL}
analyze -vhdl2k VAR_NR_INDL.vhd  
elaborate
clock -none
reset -none
check_superlint -extract
