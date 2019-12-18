config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_NO_SRST}
analyze -vhdl2k FLP_NO_SRST.vhd 
elaborate
check_superlint -extract
