config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {WIR_NO_DRIV}
analyze -sv09 WIR_NO_DRIV.v  
elaborate
check_superlint -extract
