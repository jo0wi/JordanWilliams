`timescale 1ns / 1ps

module tb_25MHz_Clk();

    reg Clk = 0;
    reg Rst = 0;
    wire Clk_25MHz;
    
    Clk_25MHz uut(Clk, Rst, Clk_25MHz);
    
    always #5 Clk = ~Clk;
    
    initial begin
    repeat(100)@(posedge Clk);
    $finish;
    end
endmodule
