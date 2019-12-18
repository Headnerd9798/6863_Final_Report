config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_XC_LDTH}
analyze -sv09 CLK_XC_LDTH.v  
elaborate
check_superlint -extract
