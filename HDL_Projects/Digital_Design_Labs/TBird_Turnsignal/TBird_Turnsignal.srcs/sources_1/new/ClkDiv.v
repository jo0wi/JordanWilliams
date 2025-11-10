`timescale 1ns / 1ps

module ClkDiv(
    input Clk,
    input DivRst,
    output ClkOut
    );
    
    integer count = 0;
    reg Clk_1Hz = 0;
    
    parameter integer HalfCLK = 50_000_000;
    
    always @(posedge Clk) begin
        if (DivRst == 0) begin
            if(count < HalfCLK - 1) begin
                count <= count + 1;
                end
            else begin
                count <= 0;
                Clk_1Hz <= ~Clk_1Hz;
                end
            end
        else 
            count = 0;
    end  
      
     assign ClkOut = Clk_1Hz;
     
endmodule
