config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FNC_NR_CREC}
analyze -sv09 FNC_NR_CREC.v  
catch elaborate
check_superlint -extract
