config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {DLY_NR_NEGT}
analyze -vhdl2k DLY_NR_NEGT.vhd  
elaborate
check_superlint -extract
