config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {INP_UC_INST}
analyze -vhdl2k bottom.vhd 
analyze -vhdl2k INP_UC_INST.vhd 
elaborate
check_superlint -extract
