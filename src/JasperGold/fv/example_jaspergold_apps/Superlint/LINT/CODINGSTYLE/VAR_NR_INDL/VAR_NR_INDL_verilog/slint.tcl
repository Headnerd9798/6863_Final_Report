config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {VAR_NR_INDL}
analyze -sv09 VAR_NR_INDL.v  
elaborate
clock -none
reset -none
check_superlint -extract
