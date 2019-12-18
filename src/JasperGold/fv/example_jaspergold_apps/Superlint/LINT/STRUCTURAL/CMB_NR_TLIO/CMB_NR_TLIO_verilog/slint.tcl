config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CMB_NR_TLIO}
analyze -sv09 CMB_NR_TLIO.v  
elaborate
check_superlint -extract
