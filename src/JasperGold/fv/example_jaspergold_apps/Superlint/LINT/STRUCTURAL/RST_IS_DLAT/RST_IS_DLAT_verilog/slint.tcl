config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {RST_IS_DLAT}
analyze -sv09 RST_IS_DLAT.v  
elaborate
clock -none
reset -none
check_superlint -extract
