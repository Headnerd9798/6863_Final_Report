module pwr_ctrl (clk, reset, 
		 idle1, idle2, idle3, idle4, 
		 reg_wr, reg_data, csr_mem,
		 iso_up, pwr_up, save, restore);

   parameter PWR_OFF = 2'd0;
   parameter PWR_EN = 2'd1;
   parameter PWR_UP = 2'd2;
   parameter PWR_IDLE = 2'd3;


   input clk, reset;
   
   //from tx/rx blocks
   input idle1, idle2, idle3, idle4;
   
   //from csr block to access memory controller registers
   input csr_mem;
   
   //regular register access for the power-controller
   input reg_wr;
   input [5:0] reg_data;
   
   //low-power signals
   output reg  iso_up;
   output reg  pwr_up;
   output reg  save;
   output reg  restore;
   
   wire        all_idle = idle1 & idle2 & idle3 & idle4 && ~csr_mem;
   
   reg 	       reg_rdy;
   reg 	       pwr_mode;
   reg [3:0]   pwr_reg;
   reg [3:0]   pwr_cnt;
   
   reg [1:0]   pwr_state;
   
   always @(posedge clk or posedge reset)
     if (reset) {pwr_mode, pwr_reg, reg_rdy} <= 6'b100000;
     else if (reg_wr) {pwr_mode, pwr_reg, reg_rdy} <= reg_data;
   
   always @(posedge clk or posedge reset)
     if (reset) pwr_state <= PWR_UP;
     else case(pwr_state)
	    PWR_OFF: if (reg_rdy) begin
               if (!pwr_mode) pwr_state <= PWR_UP;
               else if (!all_idle ) pwr_state <= PWR_EN;
            end
	    PWR_EN: if (all_idle) pwr_state <= PWR_IDLE;
            else if (pwr_cnt==pwr_reg)
              pwr_state <= PWR_UP;
	    PWR_UP: if (pwr_mode  && all_idle) pwr_state <= PWR_IDLE;
	    PWR_IDLE: if (pwr_cnt==pwr_reg) pwr_state <= PWR_OFF;
	  endcase
   

   always @(posedge clk)
     begin
     if (reset)
       begin
       pwr_up  <= 1'b1;
       iso_up  <= 1'b0;
       save    <= 1'b0;
       restore <= 1'b0;
       end
     else
       begin
       pwr_up <= !(pwr_state==PWR_OFF);
       iso_up <= !(pwr_state==PWR_UP);
       save   <= (pwr_state == PWR_IDLE);
       restore<= (pwr_state == PWR_EN);
       end       
     end
          
   always @(posedge clk)
     if (reset) pwr_cnt <= 4'b0;
     else if (pwr_cnt==pwr_reg)
       pwr_cnt <= 4'b0;
     else if (pwr_state==PWR_EN || pwr_state==PWR_IDLE)
       pwr_cnt <= pwr_cnt + 4'd1;
   
endmodule
