config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ASG_NR_NBCB}
analyze -sv09 ASG_NR_NBCB.v  
elaborate
clock -none
reset -none
check_superlint -extract
