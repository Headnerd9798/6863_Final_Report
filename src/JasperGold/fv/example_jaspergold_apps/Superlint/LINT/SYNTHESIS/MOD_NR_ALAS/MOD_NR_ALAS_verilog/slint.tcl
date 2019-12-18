config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NR_ALAS}
analyze -sv09 MOD_NR_ALAS.v  
elaborate
clock -none
reset -none
check_superlint -extract
