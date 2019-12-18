config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_IS_MCDM}
analyze -sv09 CLK_IS_MCDM.v  
elaborate
check_superlint -extract
