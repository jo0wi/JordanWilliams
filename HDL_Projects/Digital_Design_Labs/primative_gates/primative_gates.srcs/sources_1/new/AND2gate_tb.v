`timescale 1ns / 1ps


module AND2gate_tb();

    reg A_t,B_t;
    wire F_t;
    
    AND2_Gate AND2_1(A_t,B_t,F_t);
    
    initial
    begin
    
    //case0
    A_t<=0;B_t<=0;
    #1 $display("F_t=%b",F_t);
    
    //case1
    A_t<=0;B_t<=1;
    #1 $display("F_t=%b",F_t);
    
    //case2
    A_t<=1;B_t<=0;
    #1 $display("F_t=%b",F_t);
    
    //case3
    A_t<=1;B_t<=1;
    #1 $display("F_t=%b",F_t);
    
    end
    
endmodule