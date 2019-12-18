config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NO_PRTD}
analyze -sv09 MOD_NO_PRTD.v  
elaborate
clock -none
reset -none
check_superlint -extract
