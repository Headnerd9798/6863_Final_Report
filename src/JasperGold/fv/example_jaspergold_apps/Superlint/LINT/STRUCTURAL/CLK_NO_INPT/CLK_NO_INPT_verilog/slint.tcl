config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_NO_INPT}
analyze -sv09 CLK_NO_INPT.v  
elaborate
clock -none
reset -none
check_superlint -extract
