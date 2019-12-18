config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IDN_NR_AMKW}
analyze -vhdl2k IDN_NR_AMKW.vhd  
elaborate
check_superlint -extract
