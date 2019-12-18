config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {REG_NR_MNBA}
analyze -sv09 REG_NR_MNBA.v  
elaborate
clock -none
reset -none
check_superlint -extract
