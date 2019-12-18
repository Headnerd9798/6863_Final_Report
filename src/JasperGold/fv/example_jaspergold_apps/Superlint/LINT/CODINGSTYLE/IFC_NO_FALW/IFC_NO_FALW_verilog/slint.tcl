config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IFC_NO_FALW}
analyze -sv09 IFC_NO_FALW.v  
elaborate
clock -none
reset -none
check_superlint -extract
