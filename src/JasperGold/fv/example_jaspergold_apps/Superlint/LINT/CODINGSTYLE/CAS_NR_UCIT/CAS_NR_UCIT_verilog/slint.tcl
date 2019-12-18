config_rtlds -rule -disable -domain {DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CAS_NR_UCIT}
analyze -sv09 CAS_NR_UCIT.v  
elaborate
clock -none
reset -none
check_superlint -extract
