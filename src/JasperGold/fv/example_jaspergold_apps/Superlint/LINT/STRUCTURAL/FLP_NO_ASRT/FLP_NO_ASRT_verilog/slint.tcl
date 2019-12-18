config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_NO_ASRT}
analyze -sv09 FLP_NO_ASRT.v  
elaborate
check_superlint -extract
