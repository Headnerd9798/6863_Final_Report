#!/bin/csh -f

# UVM Home in Incisive
setenv UVM_HOME `ncroot`/tools/uvm-1.1

# Point to the SoC Kit Install Area
setenv SOCV_KIT_HOME `ncroot`/kits/VerificationKit

# Source the kit setup
source ${SOCV_KIT_HOME}/env.csh

# Set other envs for demo
setenv MY_WORK_AREA `pwd`
