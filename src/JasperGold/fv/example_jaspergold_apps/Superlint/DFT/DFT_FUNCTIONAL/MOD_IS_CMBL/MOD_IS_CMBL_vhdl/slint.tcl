config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_IS_CMBL}
analyze -vhdl MOD_IS_CMBL.vhd  
elaborate
check_superlint -extract
