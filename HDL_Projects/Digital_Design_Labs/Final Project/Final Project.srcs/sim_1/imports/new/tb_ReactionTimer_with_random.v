`timescale 1ns / 1ps

module tb_ReactionTimer_with_random;

reg Clk = 0;
reg Rst = 0;
reg Start = 0;
reg LCDAck = 0;
wire [12:0] RandomValue;

wire [7:0] LED;
wire [9:0] ReactionTime;
wire Cheat;
wire Slow;
wire Wait;
wire LCDUpdate;

RandomGen random(Clk, Rst, RandomValue);
ReactionTimer uut(Clk, Rst, Start, LED, ReactionTime, Cheat, Slow, Wait, RandomValue, LCDUpdate, LCDAck);

always #5 Clk = ~Clk;

initial begin
  repeat(5)@(posedge Clk);
  #2 Rst = 1;
  repeat(10)@(posedge Clk);
  #2 Rst = 0;
  repeat(10)@(posedge Clk);
// TEST 1: CHEAT
  #2 Start = 1;
  repeat(12)@(posedge Clk);
  #2 Start = 0;
  repeat(10)@(posedge Clk); // during wait period
  #2 Start = 1; 
  repeat(12)@(posedge Clk);
  #2 Start = 0;
  repeat(20)@(posedge Clk);
  //TEST 2: MEASURE REACTION TIME
  #2 Start = 1; 
  repeat(12)@(posedge Clk);
  #2 Start = 0;
  @(posedge LED);
  repeat(10)@(posedge Clk);
  #2 Start = 1;
  repeat(12)@(posedge Clk);
  #2 Start = 0;
  repeat(20)@(posedge Clk); 
  // TEST 3: SLOW
  #2 Start = 1;
  repeat(12)@(posedge Clk);
  #2 Start = 0; 
  @(posedge LED);
  wait (uut.Count == 12'h140); 
  #2 Start = 1; 
  repeat(12)@(posedge Clk);
  #2 Start = 0;
  repeat(20)@(posedge Clk);
  #2 Rst = 1;
  repeat(10)@(posedge Clk);
  #2 Rst = 0;
  repeat(10)@(posedge Clk);
end

initial begin
  @(posedge Clk);
  forever begin
    // Simulate LCD handshake
    @(posedge LCDUpdate);
    #10;
    LCDAck = 1;
    repeat(2)@(posedge Clk);
    LCDAck = 0;
    
  end
end
endmodule