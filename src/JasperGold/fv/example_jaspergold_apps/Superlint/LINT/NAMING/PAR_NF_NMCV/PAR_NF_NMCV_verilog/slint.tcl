config_rtlds -rule -load custom.def
config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {PAR_NF_NMCV}
analyze -sv09 PAR_NF_NMCV.v  
elaborate
clock -none
reset -none
check_superlint -extract
