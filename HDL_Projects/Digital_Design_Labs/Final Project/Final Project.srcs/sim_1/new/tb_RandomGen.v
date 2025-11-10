`timescale 1ns / 1ps

module tb_RandomGen();
 
    reg Clk;
    reg Rst;
    wire [12:0] RandomValue;
    
    RandomGen uut(Clk, Rst, RandomValue);
    
    initial Clk = 0;
    always #5 Clk = ~Clk;
    
    initial begin
        Rst = 0;
        
    end
endmodule
