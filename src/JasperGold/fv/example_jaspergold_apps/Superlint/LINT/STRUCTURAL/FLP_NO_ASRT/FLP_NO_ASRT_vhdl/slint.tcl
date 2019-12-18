config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {FLP_NO_ASRT}
analyze -vhdl2k FLP_NO_ASRT.vhd 
elaborate
check_superlint -extract
