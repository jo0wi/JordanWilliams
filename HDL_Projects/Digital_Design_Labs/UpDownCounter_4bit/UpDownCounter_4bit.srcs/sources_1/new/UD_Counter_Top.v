`timescale 1ns / 1ps

module UD_Counter_Top#(parameter DIV_CLK = 50_000_000)(
    input wire Clk,
    input wire Rst,
    input wire Enable,
    input wire UpDown,
    input wire DivRst,
    output wire A,
    output wire B,
    output wire C,
    output wire D,
    output wire E,
    output wire F,
    output wire G,
    output wire SegSel,
    output wire ClkOut
    );
    
    wire [3:0]Cnt;
    wire In3 = Cnt[3];
    wire In2 = Cnt[2];
    wire In1 = Cnt[1];
    wire In0 = Cnt[0];
    
    ClkDiv#(.HalfCLK(DIV_CLK)) Clk_1Hz(Clk, DivRst, ClkOut);
    UpDownCounter_4bit Cntr(ClkOut, Rst, Enable, UpDown, Cnt);
    Decoder7Seg SSD(In3, In2, In1, In0, A, B, C, D, E, F, G, SegSel);
    
endmodule
