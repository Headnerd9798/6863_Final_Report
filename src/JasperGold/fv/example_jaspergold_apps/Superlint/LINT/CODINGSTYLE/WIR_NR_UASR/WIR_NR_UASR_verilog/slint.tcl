config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {WIR_NR_UASR}
analyze -sv09 WIR_NR_UASR.v  
elaborate
clock -none
reset -none
check_superlint -extract
