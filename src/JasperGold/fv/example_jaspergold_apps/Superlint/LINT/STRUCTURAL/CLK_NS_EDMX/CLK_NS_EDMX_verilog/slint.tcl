config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_NS_EDMX}
analyze -sv09 CLK_NS_EDMX.v  
elaborate
clock -none
reset -none
check_superlint -extract
