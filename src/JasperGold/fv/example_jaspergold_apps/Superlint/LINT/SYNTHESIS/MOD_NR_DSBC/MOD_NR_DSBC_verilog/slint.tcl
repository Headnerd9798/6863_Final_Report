config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NR_DSBC}
analyze -sv09 MOD_NR_DSBC.v  
elaborate
check_superlint -extract
