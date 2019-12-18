module ip(input in, test_mode, sclk, dclk, output reg E, F, G, H, I);

reg A, B, C, D;
wire t_clk = test_mode ? 1'b0 : dclk;
assign G = A && B;
assign I = in;

always @(posedge sclk)
begin
    A <= in;
    B <= in;
end

always @(posedge t_clk)
begin
    D <= A;
    E <= D;
    C <= B;
    F <= C;
    H <= C || D;
end

endmodule

module top(input in, in2, test_mode, clk1, clk2, output reg F, M, O, Q, R);

reg G, H, L, N, P;
wire je, jf, ji, ke, kf, kg, ki;

ip J(.in(G), .test_mode(test_mode), .sclk(clk2),
     .dclk(clk1), .E(je), .F(jf), .I(ji));

ip K(.in(H), .test_mode(1'b1), .sclk(clk2),
     .dclk(clk1), .E(ke), .F(kf), .G(kg), .I(ki));

always @(posedge clk2)
begin
    H <= in2;
end

always @(posedge clk1)
begin
    N <= kg;
    O <= N;
    G <= in;
    F <= je && jf;
    L <= kf;
    M <= L;
    P <= ki;
    Q <= P;
    R <= ji;
end

endmodule


