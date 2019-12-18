config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {LAT_IS_INFR}
analyze -sv09 LAT_IS_INFR.v  
elaborate
check_superlint -extract
