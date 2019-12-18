module FNC_NR_NARG (i1); 
   input i1; 
   reg w1; 
   function indent(input my_in = 1'b1, input my_in2 = 1'b1); 
      begin 
         indent = my_in; 
      end 
   endfunction 
   always @ (i1) 
   begin w1 = indent(i1); 
   end 
endmodule

