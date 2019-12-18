config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CST_NO_DELY}
analyze -sv09 CST_NO_DELY.v  
elaborate
clock -none
reset -none
check_superlint -extract
