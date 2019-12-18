// -------------------------------------------------------
// Copyright (c) 2018 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// ------------------------------------------------------

module drink_machine ( 
	input nickel_in, dime_in, quarter_in, reset, clk,
	output reg nickel_out, dime_out, two_dime_out, dispense
	);

	enum logic [3:0] {
		s_idle, 
		s_five,
		s_ten,
		s_fifteen,
		s_twenty,
		s_twenty_five,
		s_thirty,
		s_thirty_five,
		s_forty,
		s_forty_five,
		s_fifty,
		s_nickel_out,
		s_dime_out,
		s_nickel_dime_out,
		s_two_dime_out} current_state, next_state;


	always_ff @(posedge clk)
		if (reset) 
			current_state <= s_idle; 
		else
			current_state <= next_state;


	always_comb
	begin : state_machine

		nickel_out = 0;
		dime_out = 0;
		two_dime_out = 0;
		dispense = 0;
		next_state = current_state;
		
		//
		// state transitions and output logic
		//
		unique case (current_state)

                    s_idle :                   //4'd0
                    begin
                        if (nickel_in == 1)
                            begin
                                next_state = s_five;
                            end
                        else if (dime_in == 1)
                            begin
                                next_state = s_ten;
                            end
                        else if (quarter_in == 1)
                            begin
                                next_state = s_twenty_five;
                            end
                    end
 
                    s_five :                   //4'd1
                    begin
                        if (nickel_in == 1)
                            begin
                                next_state = s_ten;
                            end
                        else if (dime_in == 1)
                            begin
                                next_state = s_fifteen;
                            end
                        else if (quarter_in == 1)
                            begin
                                next_state = s_thirty;
                            end
                    end
 
 
                    s_ten :                   //4'd2
                    begin
                        if (nickel_in == 1)
                            begin
                                next_state = s_fifteen;
                            end
                        else if (dime_in == 1)
                            begin
                                next_state = s_twenty;
                            end
                        else if (quarter_in == 1)
                            begin
                                next_state = s_thirty_five;
                            end
                    end
 
                    s_fifteen :                    //4'd3
                    begin
                        if (nickel_in == 1)
                            begin
                                next_state = s_twenty;
                            end
                        else if (dime_in == 1)
                            begin
                                next_state = s_twenty_five;
                            end
                        else if (quarter_in == 1)
                            begin
                                next_state = s_forty;
                            end
                    end
 
                    s_twenty :                   //4'd4
                    begin
                        if (nickel_in == 1)
                            begin
                                next_state = s_twenty_five;
                            end
                        else if (dime_in == 1)
                            begin
                                next_state = s_thirty;
                            end
                        else if (quarter_in == 1)
                            begin
                                next_state = s_forty_five;
                            end
                    end
 
                    s_twenty_five :                    //4'd5
                    begin
                        if(nickel_in == 1)
                            begin
                                next_state = s_thirty;
                            end
                        else if (dime_in == 1)
                            begin
                                next_state = s_thirty_five;
                            end
                        else if (quarter_in == 1)
                            begin
                                next_state = s_fifty;
                            end
                    end
 
                    s_thirty :                    //4'd6
                    begin
                        if (nickel_in == 1)
                            begin
                                next_state = s_thirty_five;
                            end
                        else if (dime_in == 1)
                            begin
                                next_state = s_forty;
                            end
                        else if (quarter_in == 1)
                            begin
                                next_state = s_nickel_out;
                            end
                    end
					
                    s_thirty_five :                    //4'd7
                    begin
                        if (nickel_in == 1)
                            begin
                                next_state = s_forty;
                            end
                        else if (dime_in == 1)
                            begin
                                next_state = s_forty_five;
                            end
                        else if (quarter_in == 1)
                            begin
                                next_state = s_dime_out;
                            end
                    end
					
                    s_forty :                    //4'd8 
                    begin
                        if (nickel_in == 1)
                            begin
                                next_state = s_forty_five;
                            end
                        else if (dime_in == 1)
                            begin
                                next_state = s_fifty;
                            end
                        else if (quarter_in == 1)
                            begin
                                next_state = s_nickel_dime_out;
                            end
                    end

                    s_forty_five :                    //4'd9
                    begin
                        if (nickel_in == 1)
                            begin
                                next_state = s_fifty;
                            end
                        else if (dime_in == 1)
                            begin
                                next_state = s_nickel_out;
                            end
                        else if (quarter_in == 1)
                            begin
                                next_state = s_two_dime_out;
                            end
                    end

                    s_fifty:                              //4'd10
                    begin
                        dispense = 1;
                        next_state = s_idle;
                    end
	
                    s_nickel_out :                    //4'd11
                    begin
                        dispense = 1;
                        nickel_out = 1;  
                       	next_state = s_idle;		
                    end
					
                    s_dime_out :                    //4'd12
                    begin
                        dispense = 1;
                        dime_out = 1;  
                        next_state = s_idle;		
                    end
					
                    s_nickel_dime_out :                    //4'd13
                    begin
                        dispense = 1;
                        nickel_out = 1;  
                        dime_out = 1;  
                        next_state = s_idle;		
                    end

                    s_two_dime_out :                    //4'd14
                    begin
                        dispense = 1; 
                        two_dime_out = 1;  
			next_state = s_idle;
		    end
		    
		    default ;

             endcase       

        end
 
endmodule

