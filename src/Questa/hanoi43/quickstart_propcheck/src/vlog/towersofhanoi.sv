
module move_disk(clk, rst, from_rod, to_rod);
   
parameter
  NUMBER_OF_RODS = 3;
   
parameter
  NUMBER_OF_DISKS = 4;  

localparam 
  RODS_LOG2 = $clog2(NUMBER_OF_RODS); // width
   
localparam    
  DISKS_LOG2 = $clog2(NUMBER_OF_DISKS);  // width

   
   input logic clk;
   input logic rst;
   input logic [(RODS_LOG2-1):0] from_rod;  // from_rod [0:2]
   input logic [(RODS_LOG2-1):0] to_rod;    // to_rod [0:2]
   
   //logic [(NUMBER_OF_RODS-1):0] [(DISKS_LOG2-1):0] top_of_rod; 
   //logic [(NUMBER_OF_RODS-1):0] [(NUMBER_OF_DISKS-1):0] [(DISKS_LOG2-1):0] rod_data;     
   
   logic [(NUMBER_OF_RODS-1):0] [(DISKS_LOG2):0] top_of_rod; 
   logic [(NUMBER_OF_RODS-1):0] [(NUMBER_OF_DISKS):0] [(DISKS_LOG2):0] rod_data;   
   
   always_ff @(posedge clk) begin
      if (rst) begin
         foreach (top_of_rod[i]) begin
            top_of_rod[i] <= 0;
         end    
         top_of_rod[0] <= NUMBER_OF_DISKS;
         foreach (rod_data[i, j]) begin
            rod_data[i][j] <= 0;
         end
         foreach (rod_data[i, j]) begin 
            if (i==0) rod_data[i][j] <= NUMBER_OF_DISKS - j;
            else rod_data[i][j] <= 0;
         end 
      end 
      else 
         if (from_rod < NUMBER_OF_RODS 
             && to_rod < NUMBER_OF_RODS 
             && top_of_rod[from_rod]>=1 
             && (top_of_rod[to_rod]==0 || 
                 rod_data[from_rod][top_of_rod[from_rod]-1] <  rod_data[to_rod][top_of_rod[to_rod]-1] )) begin
            rod_data[to_rod][top_of_rod[to_rod]] <=  rod_data[from_rod][top_of_rod[from_rod]-1];
	    rod_data[from_rod][top_of_rod[from_rod]-1] <= 0; // reset the rod_data of from_rod  ( how to find this bug)
            top_of_rod[from_rod] <= top_of_rod[from_rod] - 1;
            top_of_rod[to_rod] <= top_of_rod[to_rod] + 1;            
         end
       end 

    
   
   my_assert: assert property (@(posedge clk)
                               rod_data[1][NUMBER_OF_DISKS-1] != 1);

//////////////////////////              Reset Verify          ///////////////////////////

//reset_top_0: assert property (@(posedge clk) rst |-> top_of_rod [0] == NUMBER_OF_DISKS );

//reset_rod_data_0: assert property (@(posedge clk) rst |=> (rod_data[0][0] == 3 && rod_data[0][1] == 2 && rod_data[0][2] == 1 && rod_data[1][0] == 0 && rod_data[1][1] == 0 
//&& rod_data[1][2] == 0 && rod_data[2][0] == 0 && rod_data[2][1] == 0 && rod_data[2][2] == 0));

//top_of_rod [0] == 3 && top_of_rod [1] == 0 && top_of_rod [2] == 0 && rod_data[0][0] == 3 && rod_data[0][1] == 2 && rod_data[0][2] == 1 && rod_data[1][0] == 0 && rod_data[1][1] == 0 
//&& rod_data[1][2] == 0 && rod_data[2][0] == 0 && rod_data[2][1] == 0 && rod_data[2][2] == 0

//reset_top_0: assert property (@(posedge clk) rst |=> (top_of_rod [0] == 3 && top_of_rod [1] == 0 && top_of_rod [2] == 0 && rod_data[0][0] == 3 && rod_data[0][1] == 2 && rod_data[0][2] 
//== 1 && rod_data[1][0] == 0 && rod_data[1][1] == 0 
//&& rod_data[1][2] == 0 && rod_data[2][0] == 0 && rod_data[2][1] == 0 && rod_data[2][2] == 0));

//////////////////////////              winning goal          ///////////////////////////

assert_top_disk_1_1 :assert property (@(posedge clk) rod_data[1][NUMBER_OF_DISKS-1] != 1); // The event that top disk of rod[1] is disk[1] is always true. 

assert_top_disk_1_2 :assert property (@(posedge clk) rod_data[2][NUMBER_OF_DISKS-1] != 1); // The event that top disk of rod[2] is disk[1] is always true. 

assert_top_disk_1_3 :assert property (@(posedge clk) rod_data[2][NUMBER_OF_DISKS-1] != 1); // The event that top disk of rod[2] is disk[1] is always true. 

cover_top_disk_1_1 : cover property (@(posedge clk) rod_data[1][NUMBER_OF_DISKS-1] != 1); // The event that top disk of rod[1] is disk[1] eventually happens. 

cover_top_disk_1_2 : cover property (@(posedge clk) rod_data[2][NUMBER_OF_DISKS-1] != 1); // The event that top disk of rod[2] is disk[1] eventually happens. 

cover_top_disk_1_3 : cover property (@(posedge clk) rod_data[2][NUMBER_OF_DISKS-1] != 1); // The event that top disk of rod[2] is disk[1] eventually happens. 

///////////////////////////         test rod [0]          ////////////////////////////


cover_test_rod_0_0 : cover property (@(posedge clk) rod_data[0][NUMBER_OF_DISKS-4] == 4);
cover_test_rod_0_1 : cover property (@(posedge clk) rod_data[0][NUMBER_OF_DISKS-3] == 3);
cover_test_rod_0_2 : cover property (@(posedge clk) rod_data[0][NUMBER_OF_DISKS-2] == 2);
cover_test_rod_0_3 : cover property (@(posedge clk) rod_data[0][NUMBER_OF_DISKS-1] == 1);


/////////////////////////// bigsmall rod [0] disk[2] disk[1] //////////////////////////// 

assert_bigsmall_disk_0_21_10 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-4] == 1) && (rod_data[0][NUMBER_OF_DISKS-3] == 2)));

assert_bigsmall_disk_0_21_21 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-3] == 1) && (rod_data[0][NUMBER_OF_DISKS-2] == 2))); 

assert_bigsmall_disk_0_21_32 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-2] == 1) && (rod_data[0][NUMBER_OF_DISKS-1] == 2))); 

/////////////////////////// bigsmall rod [1] disk[2] disk[1] //////////////////////////// 

assert_bigsmall_disk_1_21_10 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-4] == 1) && (rod_data[1][NUMBER_OF_DISKS-3] == 2)));
 
assert_bigsmall_disk_1_21_21 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-3] == 1) && (rod_data[1][NUMBER_OF_DISKS-2] == 2)));

assert_bigsmall_disk_1_21_32 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-2] == 1) && (rod_data[1][NUMBER_OF_DISKS-1] == 2)));
 
/////////////////////////// bigsmall rod [2] disk[2] disk[1] //////////////////////////// 

assert_bigsmall_disk_2_21_10 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-4] == 1) && (rod_data[2][NUMBER_OF_DISKS-3] == 2)));
 
assert_bigsmall_disk_2_21_21 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-3] == 1) && (rod_data[2][NUMBER_OF_DISKS-2] == 2)));

assert_bigsmall_disk_2_21_32 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-2] == 1) && (rod_data[2][NUMBER_OF_DISKS-1] == 2)));

/////////////////////////// bigsmall rod [0] disk[3] disk[2] //////////////////////////// 

assert_bigsmall_disk_0_32_10 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-4] == 2) && (rod_data[0][NUMBER_OF_DISKS-3] == 3)));
 
assert_bigsmall_disk_0_32_21 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-3] == 2) && (rod_data[0][NUMBER_OF_DISKS-2] == 3))); 

assert_bigsmall_disk_0_32_32 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-2] == 2) && (rod_data[0][NUMBER_OF_DISKS-1] == 3))); 

/////////////////////////// bigsmall rod [1] disk[3] disk[2] //////////////////////////// 

assert_bigsmall_disk_1_32_10 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-4] == 2) && (rod_data[1][NUMBER_OF_DISKS-3] == 3)));
 
assert_bigsmall_disk_1_32_21 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-3] == 2) && (rod_data[1][NUMBER_OF_DISKS-2] == 3)));

assert_bigsmall_disk_1_32_32 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-2] == 2) && (rod_data[1][NUMBER_OF_DISKS-1] == 3))); 

/////////////////////////// bigsmall rod [2] disk[3] disk[2] //////////////////////////// 

assert_bigsmall_disk_2_32_10 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-4] == 2) && (rod_data[2][NUMBER_OF_DISKS-3] == 3)));
 
assert_bigsmall_disk_2_32_21 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-3] == 2) && (rod_data[2][NUMBER_OF_DISKS-2] == 3)));

assert_bigsmall_disk_2_32_32 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-2] == 2) && (rod_data[2][NUMBER_OF_DISKS-1] == 3)));

/////////////////////////// bigsmall rod [0] disk[3] disk[1] //////////////////////////// 

assert_bigsmall_disk_0_31_10 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-4] == 1) && (rod_data[0][NUMBER_OF_DISKS-3] == 3)));
 
assert_bigsmall_disk_0_31_21 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-3] == 1) && (rod_data[0][NUMBER_OF_DISKS-2] == 3)));

assert_bigsmall_disk_0_31_32 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-2] == 1) && (rod_data[0][NUMBER_OF_DISKS-1] == 3)));

/////////////////////////// bigsmall rod [1] disk[3] disk[1] //////////////////////////// 

assert_bigsmall_disk_1_31_10 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-4] == 1) && (rod_data[1][NUMBER_OF_DISKS-3] == 3)));
 
assert_bigsmall_disk_1_31_21 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-3] == 1) && (rod_data[1][NUMBER_OF_DISKS-2] == 3)));

assert_bigsmall_disk_1_31_32 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-2] == 1) && (rod_data[1][NUMBER_OF_DISKS-1] == 3)));

/////////////////////////// bigsmall rod [2] disk[3] disk[1] //////////////////////////// 

assert_bigsmall_disk_2_31_10 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-4] == 1) && (rod_data[2][NUMBER_OF_DISKS-3] == 3)));
 
assert_bigsmall_disk_2_31_21 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-3] == 1) && (rod_data[2][NUMBER_OF_DISKS-2] == 3)));

assert_bigsmall_disk_2_31_32 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-2] == 1) && (rod_data[2][NUMBER_OF_DISKS-1] == 3)));

/////////////////////////// bigsmall rod [0] disk[4] disk[1] //////////////////////////// 

assert_bigsmall_disk_0_41_10 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-4] == 1) && (rod_data[0][NUMBER_OF_DISKS-3] == 4)));
 
assert_bigsmall_disk_0_41_21 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-3] == 1) && (rod_data[0][NUMBER_OF_DISKS-2] == 4)));

assert_bigsmall_disk_0_41_32 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-2] == 1) && (rod_data[0][NUMBER_OF_DISKS-1] == 4)));

/////////////////////////// bigsmall rod [1] disk[4] disk[1] //////////////////////////// 

assert_bigsmall_disk_1_41_10 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-4] == 1) && (rod_data[1][NUMBER_OF_DISKS-3] == 4)));
 
assert_bigsmall_disk_1_41_21 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-3] == 1) && (rod_data[1][NUMBER_OF_DISKS-2] == 4)));

assert_bigsmall_disk_1_41_32 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-2] == 1) && (rod_data[1][NUMBER_OF_DISKS-1] == 4)));

/////////////////////////// bigsmall rod [2] disk[4] disk[1] //////////////////////////// 

assert_bigsmall_disk_2_41_10 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-4] == 1) && (rod_data[2][NUMBER_OF_DISKS-3] == 4)));
 
assert_bigsmall_disk_2_41_21 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-3] == 1) && (rod_data[2][NUMBER_OF_DISKS-2] == 4)));

assert_bigsmall_disk_2_41_32 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-2] == 1) && (rod_data[2][NUMBER_OF_DISKS-1] == 4)));

/////////////////////////// bigsmall rod [0] disk[4] disk[2] //////////////////////////// 

assert_bigsmall_disk_0_42_10 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-4] == 2) && (rod_data[0][NUMBER_OF_DISKS-3] == 4)));
 
assert_bigsmall_disk_0_42_21 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-3] == 2) && (rod_data[0][NUMBER_OF_DISKS-2] == 4)));

assert_bigsmall_disk_0_42_32 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-2] == 2) && (rod_data[0][NUMBER_OF_DISKS-1] == 4)));

/////////////////////////// bigsmall rod [1] disk[4] disk[2] //////////////////////////// 

assert_bigsmall_disk_1_42_10 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-4] == 2) && (rod_data[1][NUMBER_OF_DISKS-3] == 4)));
 
assert_bigsmall_disk_1_42_21 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-3] == 2) && (rod_data[1][NUMBER_OF_DISKS-2] == 4)));

assert_bigsmall_disk_1_42_32 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-2] == 2) && (rod_data[1][NUMBER_OF_DISKS-1] == 4)));

/////////////////////////// bigsmall rod [2] disk[4] disk[2] //////////////////////////// 

assert_bigsmall_disk_2_42_10 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-4] == 2) && (rod_data[2][NUMBER_OF_DISKS-3] == 4)));
 
assert_bigsmall_disk_2_42_21 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-3] == 2) && (rod_data[2][NUMBER_OF_DISKS-2] == 4)));

assert_bigsmall_disk_2_42_32 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-2] == 2) && (rod_data[2][NUMBER_OF_DISKS-1] == 4)));

/////////////////////////// bigsmall rod [0] disk[4] disk[3] //////////////////////////// 

assert_bigsmall_disk_0_43_10 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-4] == 3) && (rod_data[0][NUMBER_OF_DISKS-3] == 4)));
 
assert_bigsmall_disk_0_43_21 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-3] == 3) && (rod_data[0][NUMBER_OF_DISKS-2] == 4)));

assert_bigsmall_disk_0_43_32 : assert property (@(posedge clk)  not ((rod_data[0][NUMBER_OF_DISKS-2] == 3) && (rod_data[0][NUMBER_OF_DISKS-1] == 4)));

/////////////////////////// bigsmall rod [1] disk[4] disk[3] //////////////////////////// 

assert_bigsmall_disk_1_43_10 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-4] == 3) && (rod_data[1][NUMBER_OF_DISKS-3] == 4)));
 
assert_bigsmall_disk_1_43_21 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-3] == 3) && (rod_data[1][NUMBER_OF_DISKS-2] == 4)));

assert_bigsmall_disk_1_43_32 : assert property (@(posedge clk)  not ((rod_data[1][NUMBER_OF_DISKS-2] == 3) && (rod_data[1][NUMBER_OF_DISKS-1] == 4)));

/////////////////////////// bigsmall rod [2] disk[4] disk[3] //////////////////////////// 

assert_bigsmall_disk_2_43_10 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-4] == 3) && (rod_data[2][NUMBER_OF_DISKS-3] == 4)));
 
assert_bigsmall_disk_2_43_21 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-3] == 3) && (rod_data[2][NUMBER_OF_DISKS-2] == 4)));

assert_bigsmall_disk_2_43_32 : assert property (@(posedge clk)  not ((rod_data[2][NUMBER_OF_DISKS-2] == 3) && (rod_data[2][NUMBER_OF_DISKS-1] == 4)));




endmodule // move_disk


        
