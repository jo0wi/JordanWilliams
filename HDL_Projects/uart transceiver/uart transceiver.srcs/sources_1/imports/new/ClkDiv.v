`timescale 1ns / 1ps

module ClkDiv(
    input Clk,
    input DivRst,
    output reg ClkOut = 0
    );
    
    reg [27:0] count = 0;
    
    parameter CLK_SPEED = 60_000; // in Hz
    
    localparam HALF_CLK = (100_000_000/CLK_SPEED)/2;
    
    always @(posedge Clk) begin
        if (~DivRst) begin
            if(count < HALF_CLK - 1) begin
                count <= count + 1;
                end
            else begin
                count <= 0;
                ClkOut <= ~ClkOut;
                end
            end
        else 
            count = 0;
    end  
endmodule
