`timescale 1ns / 1ps

module UD_CounterTop_tb();

    reg Clk, Rst, UpDown, Enable, DivRst;
    wire A,B,C,D,E,F,G;
    
    UD_Counter_Top#(.DIV_CLK(1)) uut(Clk, Rst, Enable, UpDown, DivRst, A,B,C,D,E,F,G,SegSel,ClkOut);
    
    initial Clk = 0;
    always  #5 Clk = ~Clk;
    
    initial begin
        Rst = 0;
        Enable = 1;
        DivRst = 0;
        UpDown = 1;
        repeat(35)@(posedge Clk);
        #1 UpDown = 0;
        repeat(30)@(posedge Clk);
        #1 UpDown = 0;
        @(posedge Clk);
        #1 Enable = 0; 
        repeat(10)@(posedge Clk);
        #1 Rst = 1;
        repeat(10)@(posedge Clk);
        $finish;
    end
endmodule

