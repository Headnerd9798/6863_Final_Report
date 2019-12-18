config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IDX_MS_INDL}
analyze -vhdl2k IDX_MS_INDL.vhd  
elaborate
check_superlint -extract
