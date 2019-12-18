config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {ELB_IS_ERRO}
analyze -sv09 ELB_IS_ERRO.v  
catch elaborate
check_superlint -extract
