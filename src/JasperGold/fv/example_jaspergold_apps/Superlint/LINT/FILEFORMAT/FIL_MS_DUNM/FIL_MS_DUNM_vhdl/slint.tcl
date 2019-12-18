config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FIL_MS_DUNM}
analyze -vhdl2k FIL_MS_DUNM.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
