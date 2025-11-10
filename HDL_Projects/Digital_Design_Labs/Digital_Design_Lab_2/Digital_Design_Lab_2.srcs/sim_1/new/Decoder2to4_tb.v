`timescale 1ns / 1ps

module Decoder2to4_tb();

    reg At,Bt;
    wire Q0t,Q1t,Q2t,Q3t;
    
    //Decoder2to4 D2to4(At,Bt,Q0t,Q1t,Q2t,Q3t);
    Decoder_circuit CircuitInstance(At,Bt,Q0t,Q1t,Q2t,Q3t);
    
    initial
    begin
       At<=0;Bt<=0;
       #1 At<=0;Bt<=1;
       #1 At<=1;Bt<=0;
       #1 At<=1;Bt<=1;
       
    end
endmodule
