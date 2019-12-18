
module fifo_wrapper( clk, rst, in_read_ctrl, in_write_ctrl, in_write_data, 
             out_read_data, out_is_full, out_is_empty
             );

   
parameter
  ENTRIES = 4; 
  
localparam [31:0]  
  ENTRIES_LOG2 = $clog2(ENTRIES);
  
   input  logic       clk; 
   input  logic       rst;
   input  logic       in_read_ctrl;
   input  logic       in_write_ctrl;
   input  logic [7:0] in_write_data;
   output logic [7:0] out_read_data;
   output logic       out_is_full;
   output logic       out_is_empty;

   logic [ENTRIES_LOG2-1:0]  write_ptr;
   logic [ENTRIES_LOG2-1:0]  read_ptr;
   logic [ENTRIES-1:0] [7:0] fifo_data;
   logic [7:0]               head;
   logic [ENTRIES_LOG2:0]    number_of_current_entries; 

   logic                     out_is_full_tmp;   
   logic                     out_is_empty_tmp;
   logic                     last_out_is_empty;
   logic                     last_out_is_full; 
   
   logic                     fifo_is_correct; 

   fifo
      #(.ENTRIES(ENTRIES))
   fifo_inst
     (.clk(clk),
      .rst(rst),
      .in_read_ctrl(in_read_ctrl),
      .in_write_ctrl(in_write_ctrl),
      .in_write_data(in_write_data),
      .out_read_data(out_read_data),
      .out_is_full(out_is_full_tmp),
      .out_is_empty(out_is_empty_tmp));


always_comb  begin
   if (fifo_is_correct) begin
      out_is_full = out_is_full_tmp;
      out_is_empty = out_is_empty_tmp;
   end
   else begin 
      out_is_full = last_out_is_full;
      out_is_empty = last_out_is_empty;
   end
end

always_ff @(posedge clk) begin
   fifo_is_correct <=  rst | in_read_ctrl | in_write_ctrl;;// Correct state 
   last_out_is_full <= out_is_full;
   last_out_is_empty <= out_is_empty;
end

default clocking c0 @(posedge clk); endclocking

fifo_assume_empty: assume property (@(posedge clk) out_is_empty |-> ~in_read_ctrl );
fifo_assume_full: assume property (@(posedge clk) out_is_full |-> ~in_write_ctrl );



fifo_assume_in_rw_ctrl: assume property (@(posedge clk) !(~in_write_ctrl & ~in_read_ctrl));




fifo_num_entries_6: cover property (number_of_current_entries == 6);

fifo_num_entries_5: cover property (number_of_current_entries == 5);

fifo_num_entries_4: cover property (number_of_current_entries == 4);

fifo_num_entries_3: cover property (number_of_current_entries == 3);

fifo_num_entries_2: cover property (number_of_current_entries == 2);

fifo_num_entries_1: cover property (number_of_current_entries == 1);

fifo_num_entries_0: cover property (number_of_current_entries == 0);


endmodule
   
