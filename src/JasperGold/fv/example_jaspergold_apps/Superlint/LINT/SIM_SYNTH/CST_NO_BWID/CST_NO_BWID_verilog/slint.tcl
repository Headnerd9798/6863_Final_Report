config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CST_NO_BWID}
analyze -sv09 CST_NO_BWID.v  
elaborate
check_superlint -extract
