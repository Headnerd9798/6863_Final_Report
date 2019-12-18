config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_NR_ASMX}
analyze -sv09 FLP_NR_ASMX.v  
elaborate
clock -none
reset -none
check_superlint -extract
