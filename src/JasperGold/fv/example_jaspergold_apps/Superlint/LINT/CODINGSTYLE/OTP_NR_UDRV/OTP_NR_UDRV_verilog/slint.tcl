config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {OTP_NR_UDRV}
analyze -sv09 OTP_NR_UDRV.v  
elaborate
clock -none
reset -none
check_superlint -extract
