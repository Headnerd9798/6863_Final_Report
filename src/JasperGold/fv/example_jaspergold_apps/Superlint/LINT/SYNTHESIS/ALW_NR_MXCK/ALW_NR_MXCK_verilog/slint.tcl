config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ALW_NR_MXCK}
analyze -sv09 ALW_NR_MXCK.v  
catch elaborate
check_superlint -extract
