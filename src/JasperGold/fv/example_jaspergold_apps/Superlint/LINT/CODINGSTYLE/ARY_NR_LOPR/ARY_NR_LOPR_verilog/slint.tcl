config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ARY_NR_LOPR}
analyze -sv09 ARY_NR_LOPR.v  
elaborate
clock -none
reset -none
check_superlint -extract
