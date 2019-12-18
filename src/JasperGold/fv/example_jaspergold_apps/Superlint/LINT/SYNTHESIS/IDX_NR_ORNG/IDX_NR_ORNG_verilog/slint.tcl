config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IDX_NR_ORNG}
analyze -sv09 IDX_NR_ORNG.v  
elaborate
clock -none
reset -none
check_superlint -extract
