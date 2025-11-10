`timescale 1ns / 1ps

module UpDownCounter_tb();

    reg Clk, Rst, UpDown,Enable;
    wire [3:0]Cnt;
    
    UpDownCounter_4bit uut(Clk, Rst, Enable, UpDown, Cnt);
    
    initial Clk = 0;
    always  #5 Clk = ~Clk;
    initial begin
        Rst = 0;
        Enable = 1;
        UpDown = 1;
        repeat(20)@(posedge Clk);
        #1 Enable = 0;
        repeat(3)@(posedge Clk);
        #1 Enable = 1;
        UpDown = 0;
        repeat(25)@(posedge Clk);
        #1 Rst = 1;
        repeat(2)@(posedge Clk);
        $finish;
        

    end
endmodule
