config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {RST_IS_DDAF}
analyze -sv RST_IS_DDAF.v  
elaborate
clock -none
reset -none
check_superlint -extract
