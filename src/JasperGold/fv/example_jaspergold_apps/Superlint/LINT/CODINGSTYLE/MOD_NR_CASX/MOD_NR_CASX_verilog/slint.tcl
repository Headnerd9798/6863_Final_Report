config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NR_CASX}
analyze -sv09 MOD_NR_CASX.v  
elaborate
clock -none
reset -none
check_superlint -extract
