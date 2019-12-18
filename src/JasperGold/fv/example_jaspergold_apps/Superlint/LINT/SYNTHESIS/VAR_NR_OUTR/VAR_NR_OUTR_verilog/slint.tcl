config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {VAR_NR_OUTR}
analyze -sv09 VAR_NR_OUTR.v  
catch elaborate
check_superlint -extract
