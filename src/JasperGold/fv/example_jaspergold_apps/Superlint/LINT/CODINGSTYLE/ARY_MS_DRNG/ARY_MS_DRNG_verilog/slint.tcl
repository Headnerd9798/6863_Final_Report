config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ARY_MS_DRNG}
analyze -sv09 ARY_MS_DRNG.v  
elaborate
clock -none
reset -none
check_superlint -extract
