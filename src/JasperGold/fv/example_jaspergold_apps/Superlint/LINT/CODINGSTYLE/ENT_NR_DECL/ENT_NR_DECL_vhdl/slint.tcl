config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ENT_NR_DECL}
analyze -vhdl2k ENT_NR_DECL.vhd 
elaborate
check_superlint -extract
