config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CMB_NR_TLIO}
analyze -vhdl2k CMB_NR_TLIO.vhd 
elaborate
check_superlint -extract
