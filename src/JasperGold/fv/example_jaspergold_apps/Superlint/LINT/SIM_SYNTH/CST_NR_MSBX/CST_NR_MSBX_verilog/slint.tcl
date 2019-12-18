config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CST_NR_MSBX}
analyze -sv09 CST_NR_MSBX.v  
elaborate
check_superlint -extract
