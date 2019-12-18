config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_NO_INPT}
analyze -vhdl2k CLK_NO_INPT.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
