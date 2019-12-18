config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {LAT_NR_MXCB}
analyze -sv09 LAT_NR_MXCB.v  
elaborate
clock -none
reset -none
check_superlint -extract
