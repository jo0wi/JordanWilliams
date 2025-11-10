`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2025 02:09:06 PM
// Design Name: 
// Module Name: AND2_Gate
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


module AND2_Gate(A,B,F);

    input A,B;
    output F;
    reg F;
    
    always@(A,B)
    begin
        F <= A & B;
    end
        
endmodule
