`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2025 10:47:38 PM
// Design Name: 
// Module Name: register_8ibt_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_8ibt_tb();
    
    reg clk;
    reg rst;
    reg [7:0]in;
    wire [7:0]out;

Register_8bit uut(clk,rst,in,out);
always #5 clk = ~clk;
   
initial begin
    clk = 0;
    rst = 1;
    
    #12;
    rst = 0;
    
    in = 8'b01010101;
    #10;
    in = 8'b11001100;
    #10;
    in =8'b11110110;
    #10;
    rst = 1;
    #10;
    rst = 0;
    
    in = 8'b10101010;
    #10;
    
    $stop;
    end
endmodule
