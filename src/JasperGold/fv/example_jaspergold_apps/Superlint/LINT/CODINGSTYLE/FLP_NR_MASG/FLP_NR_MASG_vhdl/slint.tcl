config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_NR_MASG}
analyze -vhdl08 FLP_NR_MASG.vhd 
elaborate
check_superlint -extract
