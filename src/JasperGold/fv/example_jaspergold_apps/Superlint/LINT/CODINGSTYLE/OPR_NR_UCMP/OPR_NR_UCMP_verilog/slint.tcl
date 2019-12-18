config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {OPR_NR_UCMP}
analyze -sv09 OPR_NR_UCMP.v  
elaborate
clock -none
reset -none
check_superlint -extract
