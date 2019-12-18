config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ALW_NR_UNUV}
analyze -sv09 ALW_NR_UNUV.v  
elaborate
clock -none
reset -none
check_superlint -extract
