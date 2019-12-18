config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ARY_NR_LBND}
analyze -sv09 ARY_NR_LBND.v  
elaborate
check_superlint -extract
