config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_NR_ENCT}
analyze -sv09 FLP_NR_ENCT.v  
elaborate
check_superlint -extract
