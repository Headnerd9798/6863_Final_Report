config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {RST_IS_DLAT}
analyze -vhdl2k RST_IS_DLAT.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
