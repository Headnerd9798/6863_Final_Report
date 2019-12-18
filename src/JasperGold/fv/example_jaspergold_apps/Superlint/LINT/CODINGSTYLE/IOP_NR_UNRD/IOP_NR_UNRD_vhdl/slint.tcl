config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IOP_NR_UNRD}
analyze -vhdl2k IOP_NR_UNRD.vhd 
elaborate
check_superlint -extract
