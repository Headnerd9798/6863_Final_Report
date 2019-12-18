config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ASG_MS_RPAD}
analyze -sv09 ASG_MS_RPAD.v  
elaborate
clock -none
reset -none
check_superlint -extract
