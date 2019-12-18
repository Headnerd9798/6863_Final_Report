config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {OTP_NO_USED}
analyze -sv09 OTP_NO_USED.v  
elaborate
clock -none
reset -none
check_superlint -extract
