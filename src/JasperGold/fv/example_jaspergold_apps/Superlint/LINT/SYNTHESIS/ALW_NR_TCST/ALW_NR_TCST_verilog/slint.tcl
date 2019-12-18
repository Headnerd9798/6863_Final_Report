config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ALW_NR_TCST}
analyze -sv09 ALW_NR_TCST.v  
catch elaborate
check_superlint -extract
