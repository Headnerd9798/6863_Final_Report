config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FNC_NO_USED}
analyze -vhdl2k FNC_NO_USED.vhd  
elaborate
check_superlint -extract
