config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ARY_NR_SLRG}
analyze -sv09 ARY_NR_SLRG.v  
elaborate
check_superlint -extract
