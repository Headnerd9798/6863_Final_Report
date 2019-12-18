config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {OTP_UC_INST}
analyze -vhdl2k bottom.vhd 
analyze -vhdl2k OTP_UC_INST.vhd 
elaborate
check_superlint -extract
