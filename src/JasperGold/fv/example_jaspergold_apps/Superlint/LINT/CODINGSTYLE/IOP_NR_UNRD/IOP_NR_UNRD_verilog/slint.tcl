config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IOP_NR_UNRD}
analyze -sv09 IOP_NR_UNRD.v  
elaborate
check_superlint -extract
