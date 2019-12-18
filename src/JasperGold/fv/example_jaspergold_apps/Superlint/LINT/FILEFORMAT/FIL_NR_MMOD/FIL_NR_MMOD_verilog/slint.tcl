config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FIL_NR_MMOD}
analyze -sv09 FIL_NR_MMOD.v  
elaborate
clock -none
reset -none
check_superlint -extract
