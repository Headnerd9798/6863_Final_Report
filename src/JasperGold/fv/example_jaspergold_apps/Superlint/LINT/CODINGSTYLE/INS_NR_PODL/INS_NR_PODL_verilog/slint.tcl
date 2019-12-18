config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {INS_NR_PODL}
analyze -sv09 INS_NR_PODL.v  
elaborate
clock -none
reset -none
check_superlint -extract
