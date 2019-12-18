config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {REG_NR_RDBA}
analyze -sv09 REG_NR_RDBA.v  
elaborate
clock -none
reset -none
check_superlint -extract
