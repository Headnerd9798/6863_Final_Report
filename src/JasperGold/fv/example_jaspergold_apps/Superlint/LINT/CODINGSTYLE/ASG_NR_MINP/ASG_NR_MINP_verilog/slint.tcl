config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ASG_NR_MINP}
analyze -sv09 ASG_NR_MINP.v  
elaborate
clock -none
reset -none
check_superlint -extract
