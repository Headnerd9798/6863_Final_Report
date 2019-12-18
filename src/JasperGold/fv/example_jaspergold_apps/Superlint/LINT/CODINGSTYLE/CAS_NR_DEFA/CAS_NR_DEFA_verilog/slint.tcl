config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CAS_NR_DEFA}
analyze -sv09 CAS_NR_DEFA.v  
elaborate
check_superlint -extract
