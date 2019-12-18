config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {DLY_NR_ASGN}
analyze -sv09 DLY_NR_ASGN.v 
elaborate
clock -none
reset -none
check_superlint -extract
