`timescale 1ns / 1ps

module Laser_DistanceHLSM(
    input B,
    input Clk,
    input Rst,
    input S,
    output reg L = 0,
    output reg[15:0]D = 0
    );
    
    parameter   S_0 = 0, //State 0
                S_1 = 1, //State 1
                S_2 = 2, //State 2
                S_3 = 3, //State 3
                S_4 = 4, //State 4
                CLK_SPEED = 300_000_000, // Clk speed in Hz
                C = 300_000_000; // Speed of Light m/s
                
        reg [15:0] Dreg = 16'b0;
        reg [15:0] Dctr = 16'b0;
        integer State = 0;
        
        
    always @(posedge Clk) begin
        if (Rst == 1) begin
            Dctr <= 0;
            State <= S_0;        
        end
        case(State)
        S_0: begin //initaialize Dreg and lazer 
            Dreg <= 0;
            L <= 0;
            State <= S_1;
        end
        S_1: begin //wait for button press
            if (B == 1 && !Rst)
                State <= S_2;
        end
        S_2: begin //pulse laser on
            L <= 1;
            State <= S_3;   
        end
        S_3: begin // turn off laser and wait for sensor input
            L <= 0;
            if (S) begin
                State <= S_4;
            end 
            else begin
                Dctr <= Dctr + 1; // count pos edges until sensor input  
            end 
        end
        S_4: begin
            Dreg <= (Dctr /2); // calculate the distance using 300MHz clk 
            State <= S_0;
        end
        endcase
        assign D = Dreg; //Update Display value with measured distance((Dctr*(1/CLK_SPEED)*C)/2)
    end
endmodule
