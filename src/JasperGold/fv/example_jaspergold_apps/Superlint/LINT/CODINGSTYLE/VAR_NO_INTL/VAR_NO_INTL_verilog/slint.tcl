config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {VAR_NO_INTL}
analyze -sv09 VAR_NO_INTL.v  
elaborate
clock -none
reset -none
check_superlint -extract
