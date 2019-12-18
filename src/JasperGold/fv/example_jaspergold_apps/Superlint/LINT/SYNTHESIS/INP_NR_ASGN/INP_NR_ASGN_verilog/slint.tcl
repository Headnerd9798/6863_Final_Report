config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {INP_NR_ASGN}
analyze -sv09 INP_NR_ASGN.v 
elaborate
check_superlint -extract
