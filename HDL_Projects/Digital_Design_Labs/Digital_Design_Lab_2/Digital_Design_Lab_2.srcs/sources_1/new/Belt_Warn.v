`timescale 1ns / 1ps

module Belt_Warn(K,P,S,W);

    input K,P,S;
    output W;
    reg W;
    
    always@(K,P,S)
    begin
        if((K&P&~S)==1)
            W<=1;
        else
            W<=0;
    end
endmodule
