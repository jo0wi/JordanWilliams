`timescale 1ns / 1ps

module Lab2part_2_tb();

    reg A_t,B_t,C_t;
    wire Y_t;
    
    Lab2part_2 part2tb(A_t,B_t,C_t,Y_t);
    
    initial
    begin
           A_t<=0;B_t<=0;C_t<=0;
        #1 A_t<=0;B_t<=0;C_t<=1;
        #1 A_t<=0;B_t<=1;C_t<=0;
        #1 A_t<=0;B_t<=1;C_t<=1;
        #1 A_t<=1;B_t<=0;C_t<=0;
        #1 A_t<=1;B_t<=0;C_t<=1;
        #1 A_t<=1;B_t<=1;C_t<=0;
        #1 A_t<=1;B_t<=1;C_t<=1;
    end
endmodule
