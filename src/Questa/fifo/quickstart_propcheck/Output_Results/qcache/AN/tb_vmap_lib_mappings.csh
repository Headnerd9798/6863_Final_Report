#!/bin/csh -f


set vlib_exec="/tools/mentor/questa_2019.2_1/linux_x86_64/share/modeltech/linux_x86_64/vlib"
if (! -e $vlib_exec) then
  echo "** ERROR: vlib path '$vlib_exec' does not exist"
  exit 1
endif

set vmap_exec="/tools/mentor/questa_2019.2_1/linux_x86_64/share/modeltech/linux_x86_64/vmap"
if (! -e $vmap_exec) then
  echo "** ERROR: vmap path '$vmap_exec' does not exist"
  exit 1
endif

cp -f /homes/user/stud/fall19/hz2619/fifo/quickstart_propcheck/Output_Results/qcache/AN/modelsim.ini .

# $vlib_exec /homes/user/stud/fall19/hz2619/fifo/quickstart_propcheck/./work
if($status == 0) then
  $vmap_exec -modelsimini modelsim.ini work /homes/user/stud/fall19/hz2619/fifo/quickstart_propcheck/./work
else
  echo "** Error: Library mapping failed. (Command: 'vlib /homes/user/stud/fall19/hz2619/fifo/quickstart_propcheck/./work')"
endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../std
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini std /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../std
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../std')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../ieee
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini ieee /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../ieee
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../ieee')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../vital2000
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini vital2000 /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../vital2000
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../vital2000')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../verilog
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini verilog /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../verilog
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../verilog')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../std_developerskit
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini std_developerskit /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../std_developerskit
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../std_developerskit')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../synopsys
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini synopsys /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../synopsys
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../synopsys')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../modelsim_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini modelsim_lib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../modelsim_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../modelsim_lib')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../sv_std
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini sv_std /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../sv_std
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../sv_std')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../avm
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiAvm /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../avm
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../avm')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../rnm
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiRnm /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../rnm
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../rnm')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../ovm-2.1.2
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiOvm /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../ovm-2.1.2
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../ovm-2.1.2')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../uvm-1.1d
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiUvm /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../uvm-1.1d
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../uvm-1.1d')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../upf_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiUPF /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../upf_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../upf_lib')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../pa_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiPA /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../pa_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../pa_lib')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../floatfixlib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini floatfixlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../floatfixlib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../floatfixlib')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../mc2_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mc2_lib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../mc2_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../mc2_lib')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../osvvm
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini osvvm /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../osvvm
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../osvvm')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../mgc_ams
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mgc_ams /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../mgc_ams
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../mgc_ams')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../ieee_env
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini ieee_env /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../ieee_env
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../ieee_env')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../infact
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini infact /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../infact
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../infact')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../vhdlopt_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini vhdlopt_lib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../vhdlopt_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../vhdlopt_lib')"
# endif
# $vlib_exec /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../vh_ux01v_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini vh_ux01v_lib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../vh_ux01v_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /tools/mentor/questa_2019.2_1/share/modeltech/linux_x86_64/../vh_ux01v_lib')"
# endif
# $vlib_exec /homes/user/stud/fall19/hz2619/fifo/quickstart_propcheck/.//Output_Results/qcache/AN/zin_vopt_work
if($status == 0) then
  $vmap_exec -modelsimini modelsim.ini z0in_work_ctrl /homes/user/stud/fall19/hz2619/fifo/quickstart_propcheck/.//Output_Results/qcache/AN/zin_vopt_work
else
  echo "** Error: Library mapping failed. (Command: 'vlib /homes/user/stud/fall19/hz2619/fifo/quickstart_propcheck/.//Output_Results/qcache/AN/zin_vopt_work')"
endif
