`timescale 1ns / 1ps

module ClkDiv_tb();

reg Clk;
reg DivRst;
wire ClkOut;

ClkDiv #(.HalfCLK(4)) uut (.Clk(Clk), .DivRst(DivRst), .ClkOut(ClkOut));

initial Clk = 0;
always #5 Clk = ~Clk;

  initial begin
    DivRst = 0;
    #1000;
    DivRst = 1;
    #1000000;

    $finish;
  end
endmodule
