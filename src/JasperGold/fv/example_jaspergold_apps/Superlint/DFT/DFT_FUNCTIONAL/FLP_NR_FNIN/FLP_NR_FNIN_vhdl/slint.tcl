config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_NR_FNIN}
analyze -vhdl08 FLP_NR_FNIN.vhd  
elaborate
clock -none
reset -none
check_superlint -extract
