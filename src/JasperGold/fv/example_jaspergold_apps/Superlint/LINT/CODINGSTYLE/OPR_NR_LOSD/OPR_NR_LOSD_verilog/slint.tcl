config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {OPR_NR_LOSD}
analyze -sv09 OPR_NR_LOSD.v  
elaborate
check_superlint -extract
