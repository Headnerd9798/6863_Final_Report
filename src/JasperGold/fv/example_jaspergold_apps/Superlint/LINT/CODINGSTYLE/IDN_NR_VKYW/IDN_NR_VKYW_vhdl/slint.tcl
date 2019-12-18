config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IDN_NR_VKYW}
analyze -vhdl2k IDN_NR_VKYW.vhd  
elaborate
check_superlint -extract
