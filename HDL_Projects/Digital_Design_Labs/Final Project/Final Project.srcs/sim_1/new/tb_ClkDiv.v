`timescale 1ns / 1ps

module tb_ClkDiv();
    
    ClkDiv uut(Clk, Rst, ClkOut); 
    
    reg Clk = 0;
    reg Rst = 0;
    wire ClkOut;
    
    initial Clk = 0;
    always #5 Clk = ~Clk;
    
    initial begin
        Rst = 0;
        repeat(50)@(posedge Clk);
        Rst = 1;
        repeat(10)@(posedge Clk);
        Rst = 0;
        repeat(1_000)@(posedge Clk);
        
    end
endmodule
