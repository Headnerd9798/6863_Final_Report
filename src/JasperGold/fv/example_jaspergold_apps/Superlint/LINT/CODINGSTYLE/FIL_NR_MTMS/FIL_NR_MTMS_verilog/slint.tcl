config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FIL_NR_MTMS}
analyze -sv09 FIL_NR_MTMS.v  
elaborate
check_superlint -extract
