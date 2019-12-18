config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {SIG_NO_HIER}
analyze -vhdl08 SIG_NO_HIER.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
