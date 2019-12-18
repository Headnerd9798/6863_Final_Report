config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {SIG_NR_NDCL}
analyze -sv09 SIG_NR_NDCL.v  
elaborate
clock -none
reset -none
check_superlint -extract
