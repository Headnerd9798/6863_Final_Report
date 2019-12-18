config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {INP_UC_INST}
analyze -sv09 INP_UC_INST.v  
elaborate
clock -none
reset -none
check_superlint -extract
