config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ALW_NR_OPSL}
analyze -sv09 ALW_NR_OPSL.v  
elaborate
clock -none
reset -none
check_superlint -extract
