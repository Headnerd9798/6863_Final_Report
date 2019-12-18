config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ASG_NS_TRNB}
analyze -sv09 ASG_NS_TRNB.v  
elaborate
clock -none
reset -none
check_superlint -extract
