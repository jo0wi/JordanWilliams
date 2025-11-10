`timescale 1ns / 1ns

module RandomGen(Clk, Rst, RandomValue);

    input Clk, Rst;
    output [12:0] RandomValue; // you need decide the number of bits here.
    reg [12:0] Counter; //

    parameter MAX_mS = 3000, // min of random value in milliseconds
              MIN_mS = 1000; // min of random value in milliseconds
              
    
    always@(posedge Clk) begin
        if (Counter < MAX_mS && ~Rst) Counter <= Counter + 10; // increment by 10 for each 1 ms clock cycle
        else Counter <= MIN_mS; // reset to min value when max is reached or Rst is high                           
    end 
    assign RandomValue = Counter; // output the random value
endmodule
