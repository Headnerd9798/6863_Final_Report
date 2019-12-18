config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {PRT_NR_DFRG}
analyze -sv09 PRT_NR_DFRG.v  
elaborate
clock -none
reset -none
check_superlint -extract
