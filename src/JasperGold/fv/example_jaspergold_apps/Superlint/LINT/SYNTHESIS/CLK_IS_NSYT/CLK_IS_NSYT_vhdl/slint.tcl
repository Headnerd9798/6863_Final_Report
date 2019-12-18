config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {CLK_IS_NSYT}
analyze -vhdl2k CLK_IS_NSYT.vhd 
catch elaborate
check_superlint -extract
