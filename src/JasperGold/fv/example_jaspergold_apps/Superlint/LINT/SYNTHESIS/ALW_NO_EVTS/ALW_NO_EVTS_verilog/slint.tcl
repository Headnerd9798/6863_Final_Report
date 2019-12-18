config_rtlds -rule -disable -domain {DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ALW_NO_EVTS}
analyze -sv09 ALW_NO_EVTS.v 
elaborate
check_superlint -extract
