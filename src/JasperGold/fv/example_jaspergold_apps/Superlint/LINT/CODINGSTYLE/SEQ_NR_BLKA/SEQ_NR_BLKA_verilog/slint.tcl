config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {SEQ_NR_BLKA}
analyze -sv09 SEQ_NR_BLKA.v  
elaborate
clock -none
reset -none
check_superlint -extract
