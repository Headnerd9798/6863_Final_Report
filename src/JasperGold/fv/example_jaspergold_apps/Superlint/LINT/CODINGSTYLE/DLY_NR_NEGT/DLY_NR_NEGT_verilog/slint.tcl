config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {DLY_NR_NEGT}
analyze -sv09 DLY_NR_NEGT.v  
elaborate
check_superlint -extract
