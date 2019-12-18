config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FIL_MS_DUNM}
analyze -sv09 FIL_MS_DUNM.v  
elaborate
clock -none
reset -none
check_superlint -extract
