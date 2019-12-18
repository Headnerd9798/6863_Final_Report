config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FNC_NO_USED}
analyze -sv09 FNC_NO_USED.v  
elaborate
check_superlint -extract
