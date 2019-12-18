config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ASG_MS_RPAD}
analyze -vhdl2k ASG_MS_RPAD.vhd  
catch elaborate
check_superlint -extract
