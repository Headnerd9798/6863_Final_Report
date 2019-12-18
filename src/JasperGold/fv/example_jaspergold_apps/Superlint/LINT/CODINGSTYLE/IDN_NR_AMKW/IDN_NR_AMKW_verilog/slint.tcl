config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IDN_NR_AMKW}
analyze -sv09 IDN_NR_AMKW.v  
elaborate
check_superlint -extract
