#----------------------------------------
# JasperGold Version Info
# tool      : JasperGold 2019.03
# platform  : Linux 3.10.0-1062.el7.x86_64
# version   : 2019.03p002 64 bits
# build date: 2019.06.01 18:04:02 PDT
#----------------------------------------
# started Tue Dec 17 21:49:41 EST 2019
# hostname  : cadpc14
# pid       : 13966
# arguments : '-label' 'session_0' '-console' 'cadpc14:34165' '-style' 'windows' '-data' 'AQAAADx/////AAAAAAAAA3oBAAAAEABMAE0AUgBFAE0ATwBWAEU=' '-proj' '/homes/user/stud/fall19/hz2619/fv/example_jaspergold_apps/FPV/jgproject/sessionLogs/session_0' '-init' '-hidden' '/homes/user/stud/fall19/hz2619/fv/example_jaspergold_apps/FPV/jgproject/.tmp/.initCmds.tcl' 'FPV_verilog_hanoi.tcl'
# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

# Analyze design under verification files
set ROOT_PATH ../designs/reference_design/verilog_sva
set RTL_PATH ${ROOT_PATH}/source/design
set PROP_PATH ${ROOT_PATH}/source/properties

analyze -sv \
  ${RTL_PATH}/towersofhanoi54.sv \

# Elaborate design and properties
elaborate -top move_disk
