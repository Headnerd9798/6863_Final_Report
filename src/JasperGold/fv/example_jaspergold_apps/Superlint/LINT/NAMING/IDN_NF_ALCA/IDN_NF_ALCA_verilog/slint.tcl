config_rtlds -rule -load ./custom.def
config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {IDN_NF_ALCA}
analyze -sv09 IDN_NF_ALCA.v  
elaborate
clock -none
reset -none
check_superlint -extract
