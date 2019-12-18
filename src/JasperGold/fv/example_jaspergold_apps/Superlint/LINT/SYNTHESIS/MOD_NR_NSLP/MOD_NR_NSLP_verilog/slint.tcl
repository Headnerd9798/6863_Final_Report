config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NR_NSLP}
analyze -sv09 MOD_NR_NSLP.v  
catch elaborate
check_superlint -extract
