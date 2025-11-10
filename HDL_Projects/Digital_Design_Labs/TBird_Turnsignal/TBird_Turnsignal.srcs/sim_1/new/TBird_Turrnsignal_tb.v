`timescale 1ns / 1ps

module ThunderbirdFSM_tb;
  reg  Clk, Rst, Left, Right;
  wire LC, LB, LA, RA, RB, RC;

  ThunderbirdFSM dut(
    .Clk(Clk), .Rst(Rst), .Left(Left), .Right(Right),
    .LC(LC), .LB(LB), .LA(LA), .RA(RA), .RB(RB), .RC(RC)
  );

  initial Clk = 0;
  always #5 Clk = ~Clk;

  initial begin
    Rst = 1; 
    Left = 0; 
    Right = 0;
    
    repeat (2) @(posedge Clk);
    @(negedge Clk) Rst = 0;

    @(posedge Clk); 
    Left = 1;
    @(posedge Clk); 
    Left = 0;

    repeat (5) @(posedge Clk);
    Right = 1; 
    @(posedge Clk); 
    Right = 0;

    repeat (5) @(posedge Clk);
    Left = 1; 
    @(posedge Clk); 
    Left = 0;

    @(negedge Clk) Rst = 1;
    @(posedge Clk);
    @(negedge Clk) Rst = 0;

    repeat (2) @(posedge Clk);
    $finish;
  end
endmodule
