config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_NO_SRST}
analyze -sv FLP_NO_SRST.v  
elaborate
check_superlint -extract
