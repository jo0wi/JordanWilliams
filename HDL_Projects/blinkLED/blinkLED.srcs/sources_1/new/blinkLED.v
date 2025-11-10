`timescale 1ns/1ps

module PWM_generator(
    input clk, 
    output reg LED
    );
    
integer counter=0;
parameter integer halfCycle=100_000_000 /2;

always@(posedge clk) begin

    if (counter<halfCycle - 1)
        counter<=counter+1;       
        
    else begin
        counter <= 0;
        LED <= ~LED;
       
    end
end

endmodule
