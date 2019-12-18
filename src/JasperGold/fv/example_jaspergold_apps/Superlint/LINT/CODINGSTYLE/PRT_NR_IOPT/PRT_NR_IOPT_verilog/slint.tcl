config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {PRT_NR_IOPT}
analyze -sv09 PRT_NR_IOPT.v  
elaborate
clock -none
reset -none
check_superlint -extract
