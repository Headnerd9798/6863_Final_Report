config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {SIG_IS_MDRV}
analyze -sv09 SIG_IS_MDRV.v  
elaborate
clock -none
reset -none
check_superlint -extract
