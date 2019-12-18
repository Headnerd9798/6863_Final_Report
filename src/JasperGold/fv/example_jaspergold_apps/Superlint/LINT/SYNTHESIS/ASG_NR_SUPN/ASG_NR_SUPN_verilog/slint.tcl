config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ASG_NR_SUPN}
analyze -sv09 ASG_NR_SUPN.v  
elaborate
check_superlint -extract
