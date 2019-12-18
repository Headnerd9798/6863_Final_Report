config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NS_ADAS}
analyze -sv09 MOD_NS_ADAS.v  
catch elaborate
check_superlint -extract
