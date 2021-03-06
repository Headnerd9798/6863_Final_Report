`timescale 1ns / 1ns

module test_drink;


    wire dime_out, dispense, empty, exact_change, nickel_dime_out, nickel_out, two_dime_out;
     
    reg clk, nickel_in, dime_in, quarter_in, load, reset;
    reg [7:0] r_cans, r_nickels, r_dimes;
    wire [7:0] cans, nickels, dimes;

	integer psl_error_count = 0;

    drink_machine_top top(
        .clk(clk), .nickel_in(nickel_in), .dime_in(dime_in), 
        .quarter_in(quarter_in), .load(load), .reset(reset),
        .cans(r_cans), .nickels(r_nickels), .dimes(r_dimes),
        .nickel_out(nickel_out), .dime_out(dime_out), 
        .two_dime_out(two_dime_out), .dispense(dispense), 
        .empty(empty), .exact_change(exact_change)
    ); 

    initial
    begin : generate_clock
        clk <= 0;
        forever #100 clk <= ~clk;
    end

    initial
    begin : initialize_machine
        #1 
        nickel_in <= 0;
        dime_in <= 0;
        quarter_in <= 0;
        load <= 0;
        r_cans <= 0;
        r_nickels <= 0;
        r_dimes <= 0;
        reset <= 1;
        #200 reset <= 0;
        r_cans <= 5;
        r_nickels <= 2;
        r_dimes <= 15;
        load_machine;
        repeat (2) buy_drinks;
        $finish;
    end

    task buy_drinks;
        begin
            enter_nickel;
            enter_dime;
            enter_quarter;
            enter_dime;
            enter_quarter;
            enter_dime;
            enter_dime;
            enter_dime;
            enter_quarter;
            enter_nickel;
            enter_dime;
            enter_quarter;
            enter_dime;
            enter_quarter;
            enter_dime;
            enter_dime;
            enter_dime;
            enter_quarter;
            enter_quarter;
            enter_nickel;
            enter_dime;
            enter_quarter;
        end
    endtask

    task load_machine;
        begin
            #200 load <= 1;
            $display($time, "\t loading machine with %d cans", r_cans);
            #200 load <= 0;
        end 
    endtask

    task enter_nickel;
        begin
            nickel_in <= 1;
            $display($time, "\t enter nickel");
            #200 nickel_in <= 0;
        end 
    endtask

    task enter_dime;
        begin
            dime_in <= 1;
            $display($time, "\t enter dime");
            #200 dime_in <= 0;
        end 
    endtask

    task enter_quarter;
        begin
            quarter_in <= 1;
            $display($time, "\t enter quarter");
            #200 quarter_in <= 0;
        end 
    endtask

    always @(posedge dispense)
    begin
        $display($time, "\t -> drink dispensed");
        #1 $display("-------------------------------");
    end

    always @(posedge dime_out)
        $display($time, "\t dime changed");

    always @(posedge nickel_out)
        $display($time, "\t nickel changed");

    reg cnt_empty = 0;
    always @(posedge empty)
    begin
        $display($time, "\t *** machine empty! ***");
        if (cnt_empty >= 1) $finish(2);
        cnt_empty <= cnt_empty++;
    end
    
    always @(posedge exact_change)
        $display($time, "\t *** use exact change! ***");

endmodule
