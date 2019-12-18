config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {DLY_NO_CSAG}
analyze -vhdl2k DLY_NO_CSAG.vhd  
elaborate
check_superlint -extract
