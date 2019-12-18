config_rtlds -rule -disable -domain {LINT DFT AUTO_FORMAL}
config_rtlds -rule -enable -tag {MOD_IS_CMBL}
analyze -sv09 MOD_IS_CMBL.v 
elaborate
check_superlint -extract
