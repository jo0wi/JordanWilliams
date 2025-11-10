`timescale 1ns / 1ns

// Generate a 1 kHz clock from 100 MHz clock
module ClkDiv(Clk, Rst, ClkMS);

    input Clk, Rst;
    output reg ClkMS = 0;
    
    reg [16:0]count = 0; // enough bits to count to 100,000
    parameter CLK_Div = 100_000; // number of clock cycles for 1 ms period at 100 MHz input clock
    
    always@(posedge Clk) begin
        if(Rst == 1) begin
            count <= 0;
            ClkMS <= 0;
        end
        else begin
            if (count >= (CLK_Div/2 - 1)) begin // flip clock 50,000 for 1 ms period
                count <= 0;
                ClkMS <= ~ClkMS;
            end
            else begin
                count <= count + 1;
            end
        end
    end
  endmodule
