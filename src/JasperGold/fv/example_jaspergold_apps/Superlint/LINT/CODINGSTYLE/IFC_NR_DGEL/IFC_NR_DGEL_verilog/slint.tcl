config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IFC_NR_DGEL}
analyze -sv09 IFC_NR_DGEL.v  
elaborate
check_superlint -extract
