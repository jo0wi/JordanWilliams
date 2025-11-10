`timescale 1ns / 1ps

module UpDownCounter_4bit(
    input Clk,
    input Rst,
    input Enable,
    input UpDown,
    output reg [3:0]Cnt = 4'b0
    );
 
    always @(posedge Clk) begin
        if (Rst) begin
            Cnt = 0;
        end 
        else if(UpDown && Enable) begin
            if (Cnt == 4'b1111) 
                Cnt <= 0;
            else 
            Cnt = Cnt + 1;
        end 
            else if(~UpDown && Enable)begin
                if(Cnt == 4'b0000)
                Cnt <= 4'b1111;
                else 
                Cnt <= Cnt - 1;
            end 
    end
    
    
endmodule
