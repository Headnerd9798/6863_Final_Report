config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NR_PRIM}
analyze -sv09 MOD_NR_PRIM.v  
elaborate
clock -none
reset -none
check_superlint -extract
