`timescale 1ns/1ps

module Decoder7Seg_tb;
    reg  In3, In2, In1, In0;
    wire A, B, C, D, E, F, G, SegSel;

    Decoder7Seg UUT(
       In3, In2, In1,In0,
        A, B, C, D, E, F, G,SegSel);

    integer i;
    
    initial begin

        for (i = 0; i < 16; i = i + 1)
        begin
            {In3,In2,In1,In0} = i[3:0];
            #1;
        end
    end
endmodule
