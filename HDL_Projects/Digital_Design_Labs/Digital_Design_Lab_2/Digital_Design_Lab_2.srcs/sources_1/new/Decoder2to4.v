`timescale 1ns / 1ps

module Decoder2to4(A,B,Q0,Q1,Q2,Q3);

    input wire A,B;
    output reg Q0,Q1,Q2,Q3;
    
    always@(*)
    begin
    
    Q0 = 1'b0;
    Q1 = 1'b0;
    Q2 = 1'b0;
    Q3 = 1'b0;
    
        case ({A,B})
        
            2'b00: Q0 =1'b1;
            2'b01: Q1 =1'b1;
            2'b10: Q2 =1'b1;
            2'b11: Q3 =1'b1;
            
        endcase
    end
endmodule
