config_rtlds -rule -disable -domain {DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {DLY_NR_XZVL}
analyze -sv09 DLY_NR_XZVL.v 
elaborate
check_superlint -extract
