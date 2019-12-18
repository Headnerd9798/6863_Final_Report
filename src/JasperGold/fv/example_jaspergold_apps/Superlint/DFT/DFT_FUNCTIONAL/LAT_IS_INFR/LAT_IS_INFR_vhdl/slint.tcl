config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {LAT_IS_INFR}
analyze -vhdl2k LAT_IS_INFR.vhd 
elaborate
check_superlint -extract
