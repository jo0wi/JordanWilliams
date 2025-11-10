`timescale 1ns / 1ps

module TB_FSM_1Hz_Top(
    input wire Clk,
    input wire Rst,       
    input wire Left,
    input wire Right,
    input wire DivRst,
    output wire  LC, LB, LA,
    output wire  RA, RB, RC,
    output wire ClkOut
    );
    

    
    ClkDiv CLK1Hz(.Clk(Clk), .DivRst(DivRst), .ClkOut(ClkOut));
    ThunderbirdFSM FSM(.Clk(ClkOut), .Rst(Rst), .Left(Left), .Right(Right),
    .LC(LC), .LB(LB), .LA(LA), .RA(RA), .RB(RB), .RC(RC));
    
endmodule
