config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {SIG_IS_MDRV}
analyze -vhdl2k SIG_IS_MDRV.vhd 
elaborate
clock -none
reset -none
check_superlint -extract
