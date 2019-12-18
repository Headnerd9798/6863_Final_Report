config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {OTP_NR_UDRV}
analyze -vhdl2k OTP_NR_UDRV.vhd 
catch elaborate
check_superlint -extract
