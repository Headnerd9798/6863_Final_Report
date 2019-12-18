-uvmhome default
-sv
-access rwc
-incdir ${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/interface_uvc_lib/apb/sv
-incdir ${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/interface_uvc_lib/uart/sv
-incdir ${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/uart_ctrl/sv
-incdir ${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/uart_ctrl/sv/sequence_lib
-incdir ${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/uart_ctrl/sv/reset  
-incdir ${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/uart_ctrl/tb/sv
-incdir ${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/uart_ctrl/tb/tests
${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/interface_uvc_lib/apb/sv/apb_pkg.sv
${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/interface_uvc_lib/uart/sv/uart_pkg.sv
${SOCV_KIT_HOME}/designs/socv/rtl/rtl_lpw/opencores/uart16550/rtl/uart_defines.v
-F ${SOCV_KIT_HOME}/designs/socv/rtl/rtl_lpw/opencores/oc_uart.irunargs
${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/uart_ctrl/sv/reset/reset_pkg.sv
${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/uart_ctrl/sv/uart_ctrl_defines.svh
${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/uart_ctrl/sv/uart_ctrl_pkg.sv
-nowarn CVMPRO
-nowarn TSNSPK
+svseed+1
-nclibdirpath .
+UVM_VERBOSITY=MEDIUM
+UVM_TESTNAME=apb_uart_rx_tx
+define+LITLE_ENDIAN
+define+DYNAMIC_SIM
${SOCV_KIT_HOME}/soc_verification_lib/sv_cb_ex_lib/uart_ctrl/tb/sv/uart_ctrl_top.sv
-top uart_ctrl_top
-covdut uart_top
-coverage b:e
-covoverwrite
-covfile ${MY_WORK_AREA}/covfile.cf
