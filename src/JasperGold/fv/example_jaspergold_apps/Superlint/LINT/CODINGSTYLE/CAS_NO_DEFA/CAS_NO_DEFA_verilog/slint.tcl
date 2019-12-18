config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CAS_NO_DEFA}
analyze -sv09 CAS_NO_DEFA.v  
elaborate
check_superlint -extract
