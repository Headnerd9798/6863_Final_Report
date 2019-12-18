config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {LOP_NR_FCND}
analyze -sv09 LOP_NR_FCND.v  
elaborate
clock -none
reset -none
check_superlint -extract
