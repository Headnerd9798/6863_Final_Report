config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_NS_EDMX}
analyze -vhdl2k CLK_NS_EDMX.vhd  
elaborate
clock -none
reset -none
check_superlint -extract
