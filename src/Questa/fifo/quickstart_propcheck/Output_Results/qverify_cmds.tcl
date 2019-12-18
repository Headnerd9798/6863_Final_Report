# do qs_files/directives.tcl
netlist clock clk -period 10
netlist constraint rst -value 1'b0 -after_init
# end do qs_files/directives.tcl
formal compile -d fifo_wrapper
formal verify -init qs_files/fifo.init -timeout 5m
