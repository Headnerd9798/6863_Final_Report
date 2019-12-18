config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CND_NS_MBEX}
analyze -sv09 CND_NS_MBEX.v  
elaborate
clock -none
reset -none
check_superlint -extract
