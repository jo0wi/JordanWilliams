`timescale 1ns/1ps

// this module displays the byte of data received on the seven segment display (nexys a7)
module hex_to_ssd (
    input ClkOut, // uses 60KHz Clk
    input [7:0] RX_data,
    input RX_valid,
    output A,
    output B,
    output C,
    output D,
    output E,
    output F,
    output G,
    output [7:0] AN   
);

    reg [6:0] Seg_lut = 7'b0000000;
    reg [3:0] N = 4'b0;
    reg [3:0] LOWER = 4'b0;
    reg [3:0] UPPER = 4'b0;
    reg [7:0] AN_reg = 8'b00000001;
    
    always @(negedge RX_valid) begin
        LOWER <= RX_data [3:0];
        UPPER <= RX_data [7:4];
    end
    
    always @(posedge ClkOut) begin
        if (AN_reg >= 8'b10000000) begin
            AN_reg <= 8'b00000001;
        end else AN_reg <= AN_reg << 1;   
    end
    
    always @* begin
        if (~AN[0]) N = LOWER;
        else if (~AN[1]) N = UPPER;
        else N = 4'b0000;
        
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
    
    assign AN = ~AN_reg;
    assign {A,B,C,D,E,F,G} = ~Seg_lut;   
endmodule
