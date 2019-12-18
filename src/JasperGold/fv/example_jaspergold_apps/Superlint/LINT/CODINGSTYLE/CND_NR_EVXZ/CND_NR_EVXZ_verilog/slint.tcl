config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CND_NR_EVXZ}
analyze -sv09 CND_NR_EVXZ.v  
elaborate
check_superlint -extract
