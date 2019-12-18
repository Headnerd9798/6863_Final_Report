config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {VAR_NR_TIME}
analyze -sv09 VAR_NR_TIME.v  
elaborate
clock -none
reset -none
check_superlint -extract
