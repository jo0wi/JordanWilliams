`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2025 09:00:34 PM
// Design Name: 
// Module Name: Register_8bit
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


module Register_8bit(
    input clk,
    input rst,
    input [7:0] in,
    output reg[7:0]out
    );
    
    always @(posedge clk)
    begin
        if(rst)
            out <= 8'b0;
        else
            out <= in;
    end

endmodule
