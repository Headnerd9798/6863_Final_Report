config_rtlds -rule -disable -domain {DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ALW_NR_MSLV}
analyze -sv09 ALW_NR_MSLV.v 
elaborate
check_superlint -extract
