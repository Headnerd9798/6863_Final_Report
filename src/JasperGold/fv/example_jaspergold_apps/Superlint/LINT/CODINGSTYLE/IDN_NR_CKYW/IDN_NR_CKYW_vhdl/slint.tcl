config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IDN_NR_CKYW}
analyze -vhdl2k IDN_NR_CKYW.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
