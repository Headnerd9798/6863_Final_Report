config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CAS_NR_CMUL}
analyze -sv09 CAS_NR_CMUL.v  
elaborate
clock -none
reset -none
check_superlint -extract
