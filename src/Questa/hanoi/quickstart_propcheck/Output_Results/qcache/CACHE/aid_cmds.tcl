# 
# Questa Static Verification System
# Version 2019.2_1 linux_x86_64 18 May 2019

clear settings -all
clear directives
netlist clock clk -period 10 
netlist constraint rst -value 1'b0 -after_init 
formal compile -d move_disk
formal verify  -init  $env(SRC_ROOT)//homes/user/stud/fall19/hz2619/hanoi/quickstart_propcheck/qs_files/twoersofhanoi.init -timeout 5m
