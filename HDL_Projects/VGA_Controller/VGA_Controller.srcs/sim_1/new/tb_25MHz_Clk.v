`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2025 01:30:41 PM
// Design Name: 
// Module Name: tb_25MHz_Clk
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


module tb_25MHz_Clk();

    reg Clk = 0;
    reg Rst = 0;
    wire Clk_25MHz;
    
    Clk_25MHz uut(Clk, Rst, Clk_25MHz);
    
    always #5 Clk = ~Clk;
    
    initial begin
    repeat(100)@(posedge Clk);
    $finish;
    end
endmodule
