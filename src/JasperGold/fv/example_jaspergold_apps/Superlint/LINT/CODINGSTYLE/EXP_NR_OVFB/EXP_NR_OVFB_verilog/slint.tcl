config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {EXP_NR_OVFB}
analyze -sv09 EXP_NR_OVFB.v  
elaborate
check_superlint -extract
