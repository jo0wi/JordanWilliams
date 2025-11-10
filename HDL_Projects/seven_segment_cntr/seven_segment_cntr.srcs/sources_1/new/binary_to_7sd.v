`timescale 1ns / 1ps
//making a hex encoder for seven segment display to use in a timer or maybe a clock

module binary_to_7sd(
    input clk, [3:0] bin_num,
    output A, B, C, D, E, F, G
    );
    
    reg [6:0] hex_encoding = 7'h00;
    
    always @(posedge clk)
    begin
    case (bin_num)
    4'b0000 : hex_encoding <= 7'h7E;
    4'b0001 : hex_encoding <= 7'h30;
    4'b0010 : hex_encoding <= 7'h6D;
    4'b0011 : hex_encoding <= 7'h79;
    4'b0100 : hex_encoding <= 7'h33;
    4'b0101 : hex_encoding <= 7'h5B;
    4'b0110 : hex_encoding <= 7'h5F;
    4'b0111 : hex_encoding <= 7'h70;
    4'b1000 : hex_encoding <= 7'h7F;
    4'b1001 : hex_encoding <= 7'h7B;
    4'b1010 : hex_encoding <= 7'h77;
    4'b1011 : hex_encoding <= 7'h1F;
    4'b1100 : hex_encoding <= 7'h4E;
    4'b1101 : hex_encoding <= 7'h3D;
    4'b1110 : hex_encoding <= 7'h4F;
    4'b1111 : hex_encoding <= 7'h47;
    
endmodule
