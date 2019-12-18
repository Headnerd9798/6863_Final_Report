config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ASG_NR_NBFC}
analyze -sv09 ASG_NR_NBFC.v  
catch elaborate
check_superlint -extract
