config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_NR_ASRT}
analyze -vhdl2k FLP_NR_ASRT.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
