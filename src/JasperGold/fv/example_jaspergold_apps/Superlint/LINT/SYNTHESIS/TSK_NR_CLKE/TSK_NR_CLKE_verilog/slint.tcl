config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {TSK_NR_CLKE}
analyze -sv09 TSK_NR_CLKE.v  
catch elaborate
check_superlint -extract
