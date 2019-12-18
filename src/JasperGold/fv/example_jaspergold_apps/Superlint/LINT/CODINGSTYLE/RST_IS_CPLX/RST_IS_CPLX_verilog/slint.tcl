config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {RST_IS_CPLX}
analyze -sv09 RST_IS_CPLX.v  
elaborate
clock -none
reset -none
check_superlint -extract
