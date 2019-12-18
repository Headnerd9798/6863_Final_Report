config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_IS_RBXE}
set_resilient_compilation on
analyze -sv09 MOD_IS_RBXE.v  
elaborate
clock -none
reset -none
check_superlint -extract
