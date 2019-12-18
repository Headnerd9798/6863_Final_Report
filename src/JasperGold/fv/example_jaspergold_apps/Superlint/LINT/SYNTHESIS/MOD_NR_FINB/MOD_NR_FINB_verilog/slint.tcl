config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NR_FINB}
analyze -sv09 MOD_NR_FINB.v  
elaborate
check_superlint -extract
