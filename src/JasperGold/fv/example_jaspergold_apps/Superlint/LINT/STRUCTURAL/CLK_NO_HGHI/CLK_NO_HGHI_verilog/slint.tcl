config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_NO_HGHI}
analyze -sv09 CLK_NO_HGHI.v  
elaborate
check_superlint -extract
