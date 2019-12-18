config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CND_IR_CCAS}
analyze -sv09 CND_IR_CCAS.v  
elaborate
check_superlint -extract
