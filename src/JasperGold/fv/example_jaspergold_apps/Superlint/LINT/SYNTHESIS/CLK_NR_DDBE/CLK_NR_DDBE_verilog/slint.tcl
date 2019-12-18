config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_NR_DDBE}
analyze -sv09 CLK_NR_DDBE.v  
elaborate
check_superlint -extract
