config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CAS_NR_EXCS}
analyze -sv09 CAS_NR_EXCS.v  
elaborate
check_superlint -extract
