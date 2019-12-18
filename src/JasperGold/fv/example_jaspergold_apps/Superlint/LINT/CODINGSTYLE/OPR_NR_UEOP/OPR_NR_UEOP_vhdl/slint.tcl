config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {OPR_NR_UEOP}
analyze -vhdl2k OPR_NR_UEOP.vhd  
catch elaborate
check_superlint -extract
