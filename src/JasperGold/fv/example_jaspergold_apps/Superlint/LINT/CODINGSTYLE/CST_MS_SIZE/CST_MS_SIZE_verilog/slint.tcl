config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CST_MS_SIZE}
analyze -sv09 CST_MS_SIZE.v  
elaborate
clock -none
reset -none
check_superlint -extract
