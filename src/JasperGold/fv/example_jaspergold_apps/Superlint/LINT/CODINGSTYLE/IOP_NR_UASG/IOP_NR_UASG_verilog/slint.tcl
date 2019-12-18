config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IOP_NR_UASG}
analyze -sv09 IOP_NR_UASG.v  
elaborate
clock -none
reset -none
check_superlint -extract
