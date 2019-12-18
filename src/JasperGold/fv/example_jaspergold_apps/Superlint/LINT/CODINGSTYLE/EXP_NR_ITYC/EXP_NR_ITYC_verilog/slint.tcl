config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {EXP_NR_ITYC}
analyze -sv09 EXP_NR_ITYC.v  
elaborate
check_superlint -extract
