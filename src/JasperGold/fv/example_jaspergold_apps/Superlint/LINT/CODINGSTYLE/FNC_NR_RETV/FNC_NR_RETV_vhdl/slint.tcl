config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FNC_NR_RETV}
analyze -vhdl2k FNC_NR_RETV.vhd 
elaborate
check_superlint -extract
