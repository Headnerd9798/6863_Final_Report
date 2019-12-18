config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CST_MS_LPDZ}
analyze -sv09 CST_MS_LPDZ.v  
elaborate
check_superlint -extract
