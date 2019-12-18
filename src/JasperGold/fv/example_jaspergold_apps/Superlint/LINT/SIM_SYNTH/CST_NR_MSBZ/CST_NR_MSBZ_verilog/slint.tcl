config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CST_NR_MSBZ}
analyze -sv09 CST_NR_MSBZ.v  
elaborate
clock -none
reset -none
check_superlint -extract
