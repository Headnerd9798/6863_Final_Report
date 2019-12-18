config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_NO_PRTD}
analyze -vhdl2k MOD_NO_PRTD.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
