`timescale 1ns / 1ps

module Belt_Warn_tb();

    reg K_t,P_t,S_t;
    wire W_t;
    
    //Belt_Warn BW_1(K_t,P_t,S_t,W_t);
    BeltWarn_Circuit BW_C(K_t,P_t,S_t,W_t);

    
    initial
    begin
    
    K_t<=0;P_t<=0;S_t<=0;
    #1 K_t<=0;P_t<=0;S_t<=1;
    #1 K_t<=0;P_t<=1;S_t<=0;
    #1 K_t<=0;P_t<=1;S_t<=1;
    #1 K_t<=1;P_t<=0;S_t<=0;
    #1 K_t<=1;P_t<=0;S_t<=1;
    #1 K_t<=1;P_t<=1;S_t<=0;
    #1 K_t<=1;P_t<=1;S_t<=1;

    
    
    end
endmodule
