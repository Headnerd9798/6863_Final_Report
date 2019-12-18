config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IDN_NR_SVKW}
analyze -v2k IDN_NR_SVKW.v  
elaborate
clock -none
reset -none
check_superlint -extract
