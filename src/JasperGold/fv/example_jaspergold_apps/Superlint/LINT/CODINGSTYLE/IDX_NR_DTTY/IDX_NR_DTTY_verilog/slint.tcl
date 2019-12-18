config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IDX_NR_DTTY}
analyze -sv09 IDX_NR_DTTY.v  
elaborate
clock -none
reset -none
check_superlint -extract
