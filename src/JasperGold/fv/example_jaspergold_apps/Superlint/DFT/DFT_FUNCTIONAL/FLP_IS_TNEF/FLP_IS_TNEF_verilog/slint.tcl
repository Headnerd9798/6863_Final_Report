config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_IS_TNEF}
analyze -sv FLP_IS_TNEF.v  
elaborate
clock -none
reset -none
check_superlint -extract
