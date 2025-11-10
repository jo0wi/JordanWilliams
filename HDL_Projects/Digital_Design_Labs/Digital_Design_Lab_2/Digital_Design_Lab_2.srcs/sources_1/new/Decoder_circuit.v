`timescale 1ns / 1ps

module Decoder_circuit(A,B,Q0,Q1,Q2,Q3);

    input A,B;
    output Q0,Q1,Q2,Q3;
    
    wire nA, nB;

    not (nA, A);
    not (nB, B); 

    and (Q0, nA, nB);
    and (Q1, nA, B); 
    and (Q2, A, nB);  
    and (Q3, A, B);  
      
endmodule
