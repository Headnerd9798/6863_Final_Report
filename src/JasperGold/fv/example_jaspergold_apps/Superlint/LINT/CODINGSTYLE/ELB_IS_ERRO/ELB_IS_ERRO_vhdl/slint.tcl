config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ELB_IS_ERRO}
analyze -vhdl2k ELB_IS_ERRO.vhd 
catch elaborate
check_superlint -extract
