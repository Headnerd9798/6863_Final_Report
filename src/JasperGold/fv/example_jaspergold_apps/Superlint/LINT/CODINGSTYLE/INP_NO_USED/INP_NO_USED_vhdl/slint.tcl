config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {INP_NO_USED}
analyze -vhdl2k INP_NO_USED.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
