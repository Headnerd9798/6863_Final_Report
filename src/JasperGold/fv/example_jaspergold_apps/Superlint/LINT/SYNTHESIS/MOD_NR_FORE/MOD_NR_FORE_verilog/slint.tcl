config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NR_FORE}
analyze -sv09 MOD_NR_FORE.v  
catch elaborate
check_superlint -extract
