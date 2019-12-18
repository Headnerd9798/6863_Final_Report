config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {WIR_NO_LDDR}
analyze -sv09 WIR_NO_LDDR.v  
elaborate
check_superlint -extract
