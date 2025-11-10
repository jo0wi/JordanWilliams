`timescale 1ns / 1ps

module tb_ReactionTimer;

reg Clk;
reg Rst;
reg Start;
reg LCDAck;
reg [12:0] RandomValue;

wire [7:0] LED;
wire [9:0] ReactionTime;
wire Cheat;
wire Slow;
wire Wait;
wire LCDUpdate;


ReactionTimer uut(Clk, Rst, Start, LED, ReactionTime, Cheat, Slow, Wait, RandomValue, LCDUpdate, LCDAck);

initial Clk = 0;
always #5 Clk = ~Clk;

initial begin
  Rst = 0;
  Start = 0;
  RandomValue = 1500; // fixed random value for testing
  LCDAck = 0;
  repeat(3)@(posedge Clk);
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
  RandomValue = 10;
  #2 Start = 1; 
  repeat(12)@(posedge Clk);
  #2 Start = 0; 
  @(posedge LED);
  repeat(100)@(posedge Clk);
  #2 Start = 1;
  repeat(12)@(posedge Clk);
  #2 Start = 0; 
  // TEST 3: SLOW
  repeat(20)@(posedge Clk);
  #2 Start = 1;
  repeat(12)@(posedge Clk);
  #2 Start = 0; 
  repeat(10)@(posedge Clk); 
  #2 Start = 1;
  repeat(12)@(posedge Clk);
  #2 Start = 0;
  repeat(15)@(posedge Clk); // during wait period
  #2 Start = 1; 
  repeat(12)@(posedge Clk);
  #2 Start = 0;
  @(posedge LED);
  repeat(1000)@(posedge Clk); 
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