config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FNC_NR_AVGV}
analyze -sv09 FNC_NR_AVGV.v  
elaborate
clock -none
reset -none
check_superlint -extract
