`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2025 12:38:48 PM
// Design Name: 
// Module Name: Laser_FSM_tb
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



module tb_Laser_FSM;
    reg clk, rst, btn;
    wire lzr;
    
    Laser_FSM uut (.clk(clk), .rst(rst), .btn(btn), .lzr(lzr));
    
    always #5 clk = ~clk;  // 10ns clock
    
    initial begin
        clk = 0; rst = 1; btn = 0;
        #10 rst = 0;
        
        #10 btn = 1;  // press button
        #10 btn = 0;
        
        #100 btn = 1; // press again after laser ends
        #10 btn = 0;
        
        #200 $stop;
    end
endmodule

