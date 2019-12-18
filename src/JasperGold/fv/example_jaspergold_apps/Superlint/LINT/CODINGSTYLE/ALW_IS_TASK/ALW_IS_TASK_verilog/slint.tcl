config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ALW_IS_TASK}
analyze -sv09 ALW_IS_TASK.v  
elaborate
clock -none
reset -none
check_superlint -extract
