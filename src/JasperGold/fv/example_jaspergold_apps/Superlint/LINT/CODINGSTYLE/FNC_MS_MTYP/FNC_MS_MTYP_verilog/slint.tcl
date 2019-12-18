config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FNC_MS_MTYP}
analyze -sv09 FNC_MS_MTYP.v  
elaborate
clock -none
reset -none
check_superlint -extract
