config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {SIG_IS_INTB}
analyze -sv09 SIG_IS_INTB.v  
elaborate
clock -none
reset -none
check_superlint -extract
