config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {RST_IS_DCMB}
analyze -vhdl2k RST_IS_DCMB.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
