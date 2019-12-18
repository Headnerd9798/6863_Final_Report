config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CAS_NO_DEFA}
analyze -vhdl2k CAS_NO_DEFA.vhd 
catch elaborate
check_superlint -extract
