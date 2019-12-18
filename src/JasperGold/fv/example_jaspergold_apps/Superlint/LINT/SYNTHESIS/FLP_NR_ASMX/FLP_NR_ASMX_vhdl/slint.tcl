config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_NR_ASMX}
analyze -vhdl2k FLP_NR_ASMX.vhd 
elaborate
check_superlint -extract
