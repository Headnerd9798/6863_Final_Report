config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {WIR_NO_READ}
analyze -sv09 WIR_NO_READ.v  
elaborate
clock -none
reset -none
check_superlint -extract
