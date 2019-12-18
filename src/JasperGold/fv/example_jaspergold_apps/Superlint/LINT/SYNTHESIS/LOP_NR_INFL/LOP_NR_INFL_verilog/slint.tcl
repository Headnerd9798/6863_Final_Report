config_rtlds -rule -disable -domain {DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {LOP_NR_INFL}
analyze -sv09 LOP_NR_INFL.v  
catch elaborate
check_superlint -extract
