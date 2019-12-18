config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CST_NO_DELY VAR_NR_TIME}
analyze -vhdl2k CST_NO_DELY.vhd  
elaborate
clock -none
reset -none
check_superlint -extract
