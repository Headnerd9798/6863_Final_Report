config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ALW_NR_UNUV}
analyze -vhdl2k ALW_NR_UNUV.vhd
elaborate
clock -none
reset -none
check_superlint -extract
