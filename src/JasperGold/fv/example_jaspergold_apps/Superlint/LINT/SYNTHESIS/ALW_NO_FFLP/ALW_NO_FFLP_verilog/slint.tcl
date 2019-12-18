config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ALW_NO_FFLP}
analyze -sv09 ALW_NO_FFLP.v  
elaborate
clock -none
reset -none
check_superlint -extract
