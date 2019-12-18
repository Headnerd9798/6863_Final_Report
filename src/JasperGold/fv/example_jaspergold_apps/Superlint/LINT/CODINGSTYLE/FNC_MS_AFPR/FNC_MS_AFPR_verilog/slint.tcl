config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FNC_MS_AFPR}
analyze -sv09 FNC_MS_AFPR.v  
elaborate
clock -none
reset -none
check_superlint -extract
