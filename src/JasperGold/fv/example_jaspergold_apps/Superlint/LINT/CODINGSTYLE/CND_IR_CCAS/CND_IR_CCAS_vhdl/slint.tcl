config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CND_IR_CCAS}
analyze -vhdl2k CND_IR_CCAS.vhd 
elaborate
check_superlint -extract
