`timescale 1ns / 1ps

module BeltWarn_Circuit(K,P,S,W);

    input K,P,S;
    output W;
    
    wire nS, KandP;
    
    not (nS, S);
    and(KandP, K, P);
    and(W, KandP, nS);
    
endmodule
