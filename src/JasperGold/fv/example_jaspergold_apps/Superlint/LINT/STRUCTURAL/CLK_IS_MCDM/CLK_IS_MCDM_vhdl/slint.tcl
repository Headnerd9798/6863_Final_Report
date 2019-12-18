config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_IS_MCDM}
analyze -vhdl2k CLK_IS_MCDM.vhd  
elaborate
check_superlint -extract
