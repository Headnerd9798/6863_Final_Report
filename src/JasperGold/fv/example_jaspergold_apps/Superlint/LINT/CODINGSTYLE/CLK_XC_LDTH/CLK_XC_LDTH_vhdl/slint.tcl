config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_XC_LDTH}
analyze -vhdl2k CLK_XC_LDTH.vhd  
elaborate
check_superlint -extract
