config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IDN_NR_CKYW}
analyze -sv09 IDN_NR_CKYW.v  
elaborate
clock -none
reset -none
check_superlint -extract
