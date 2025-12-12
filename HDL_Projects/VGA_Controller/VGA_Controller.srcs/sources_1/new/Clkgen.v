`timescale 1ns / 1ps

module Clk_25MHz(
    input Clk,
    input Rst,
    output reg Clk_Out = 0
    );
    
    parameter Clk_Speed = 25_000_000;
    parameter Sys_Clk = 100_000_000;
    
    reg [0:1]count = 0;
    
    always @(posedge Clk) begin
        if (Rst)begin
            Clk_Out <= 0;
            count <= 0;
        end
        else if (count >= (Sys_Clk / (2 * Clk_Speed) - 1)) begin
            count <= 0;
            Clk_Out <= ~Clk_Out;
        end
        else count <= count + 1;
    end
endmodule
