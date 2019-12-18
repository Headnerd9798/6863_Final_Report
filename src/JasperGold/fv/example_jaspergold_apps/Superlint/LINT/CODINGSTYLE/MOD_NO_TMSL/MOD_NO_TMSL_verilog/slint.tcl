config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NO_TMSL}
analyze -sv09 MOD_NO_TMSL.v  
elaborate
check_superlint -extract
