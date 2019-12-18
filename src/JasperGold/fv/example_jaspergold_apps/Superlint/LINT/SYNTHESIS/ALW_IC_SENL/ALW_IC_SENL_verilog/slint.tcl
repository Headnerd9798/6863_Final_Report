config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ALW_IC_SENL}
analyze -sv09 ALW_IC_SENL.v  
elaborate
clock -none
reset -none
check_superlint -extract
