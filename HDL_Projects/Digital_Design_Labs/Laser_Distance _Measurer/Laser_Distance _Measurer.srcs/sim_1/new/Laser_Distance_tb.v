`timescale 1ns / 1ps

module Laser_Distance_tb();
reg Clk;
reg Rst;
reg B;
reg S;
wire L;
wire [15:0]D;

Laser_DistanceHLSM uut(B, Clk, Rst, S, L, D);

initial Clk = 0;
always #5 Clk = ~Clk;

initial begin
    Rst = 1;
    S = 0;
    B = 0;
    @(posedge Clk);
    #1 Rst = 0;
    repeat(3)@(posedge Clk);
    #1 B = 1;
    @(posedge Clk);
    #1 B = 0;
    repeat(10)@(posedge Clk);
    S = 1;
    @(posedge Clk);
    S = 0;
    repeat(10)@(posedge Clk);
    
    $finish;
end
endmodule
