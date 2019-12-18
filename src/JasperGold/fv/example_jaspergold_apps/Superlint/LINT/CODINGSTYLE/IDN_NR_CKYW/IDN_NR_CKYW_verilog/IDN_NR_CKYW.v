module IDN_NR_CKYW (delete,dynamic_cast,explicit,double );
   input delete, dynamic_cast, explicit;
   output double;

   assign double = delete & (dynamic_cast | explicit);
endmodule 
