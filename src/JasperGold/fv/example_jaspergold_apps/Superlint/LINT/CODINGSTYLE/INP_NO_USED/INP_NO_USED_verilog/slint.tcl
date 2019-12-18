config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {INP_NO_USED}
analyze -sv09 INP_NO_USED.v  
elaborate
clock -none
reset -none
check_superlint -extract
