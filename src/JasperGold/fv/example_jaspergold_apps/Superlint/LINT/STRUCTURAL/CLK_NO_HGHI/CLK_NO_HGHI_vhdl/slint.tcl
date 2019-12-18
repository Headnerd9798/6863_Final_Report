config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_NO_HGHI}
analyze -vhdl2k CLK_NO_HGHI.vhd 
elaborate
check_superlint -extract
