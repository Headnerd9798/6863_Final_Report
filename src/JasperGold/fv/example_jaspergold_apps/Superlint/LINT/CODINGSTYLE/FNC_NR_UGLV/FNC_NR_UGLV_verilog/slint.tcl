config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FNC_NR_UGLV}
analyze -sv09 FNC_NR_UGLV.v  
elaborate
clock -none
reset -none
check_superlint -extract
