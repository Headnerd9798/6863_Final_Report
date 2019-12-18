config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NR_SYXZ}
analyze -sv09 MOD_NR_SYXZ.v  
elaborate
check_superlint -extract
