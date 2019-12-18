config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {TSK_NR_ASGV}
analyze -sv09 TSK_NR_ASGV.v  
elaborate
clock -none
reset -none
check_superlint -extract
