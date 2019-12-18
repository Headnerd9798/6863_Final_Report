config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CND_NR_EVXZ}
analyze -vhdl2k CND_NR_EVXZ.vhd 
elaborate
check_superlint -extract
