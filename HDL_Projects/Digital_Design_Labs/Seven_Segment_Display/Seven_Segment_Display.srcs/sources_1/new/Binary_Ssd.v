`timescale 1ns/1ps

module Decoder7Seg (
    input  wire In3,
    input  wire In2,
    input  wire In1,
    input  wire In0,
    output wire A,
    output wire B,
    output wire C,
    output wire D,
    output wire E,
    output wire F,
    output wire G,
    output wire SegSel
);
    wire [3:0] N = {In3,In2,In1,In0};

    reg [6:0] Seg_lut;
    always @* begin
        case (N)
            4'h0: Seg_lut = 7'b1111110; // 0
            4'h1: Seg_lut = 7'b0110000; // 1
            4'h2: Seg_lut = 7'b1101101; // 2
            4'h3: Seg_lut = 7'b1111001; // 3
            4'h4: Seg_lut = 7'b0110011; // 4
            4'h5: Seg_lut = 7'b1011011; // 5
            4'h6: Seg_lut = 7'b1011111; // 6
            4'h7: Seg_lut = 7'b1110000; // 7
            4'h8: Seg_lut = 7'b1111111; // 8
            4'h9: Seg_lut = 7'b1111011; // 9
            4'hA: Seg_lut = 7'b1110111; // A
            4'hB: Seg_lut = 7'b0011111; // b
            4'hC: Seg_lut = 7'b1001110; // C
            4'hD: Seg_lut = 7'b0111101; // d
            4'hE: Seg_lut = 7'b1001111; // E
            4'hF: Seg_lut = 7'b1000111; // F
            default: Seg_lut = 7'b0000000;
        endcase
    end

    wire [6:0] Seg_out = Seg_lut;
    assign {A,B,C,D,E,F,G} = Seg_out;
    assign SegSel = 1'b0;
    
endmodule
