config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {WIR_NO_DRIV}
analyze -vhdl2k WIR_NO_DRIV.vhd 
elaborate
check_superlint -extract
