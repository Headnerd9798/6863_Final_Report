config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CAS_NR_DEFX}
analyze -vhdl2k CAS_NR_DEFX.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
