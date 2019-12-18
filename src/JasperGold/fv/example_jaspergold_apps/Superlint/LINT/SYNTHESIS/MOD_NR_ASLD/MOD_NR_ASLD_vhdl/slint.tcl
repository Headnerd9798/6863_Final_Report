config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NR_ASLD}
analyze -vhdl2k MOD_NR_ASLD.vhd  
elaborate
clock -none
reset -none
check_superlint -extract
