`timescale 1ns / 1ps

module ThunderbirdFSM (
    input  wire Clk,
    input  wire Rst,       
    input  wire Left,
    input  wire Right,
    output reg  LC, LB, LA,
    output reg  RA, RB, RC
);

    // State encoding
    localparam S_Off = 3'd0,
               S_L1 = 3'd1,
               S_L2 = 3'd2,
               S_L3 = 3'd3,
               S_R1 = 3'd4,
               S_R2 = 3'd5,
               S_R3 = 3'd6;

    reg [2:0] State; 
    reg [2:0] StateNext;

    always @(posedge Clk) begin
        LA = 0; 
        LB = 0; 
        LC = 0;
        RA = 0; 
        RB = 0; 
        RC = 0;
        StateNext = State;

        case (State)
            S_Off: begin
                // Decide which sequence to start
                if (Left  && !Right) 
                    StateNext = S_L1;
                else if (Right && !Left)  
                    StateNext = S_R1;
            end
            // Left sequence
            S_L1: begin
                LA = 1;
                StateNext = S_L2;
            end
            S_L2: begin
                LA = 1; 
                LB = 1;
                StateNext = S_L3;
            end
            S_L3: begin
                LA = 1; 
                LB = 1; 
                LC = 1;
                StateNext = S_Off;
            end
            // Right sequence
            S_R1: begin
                RA = 1;
                StateNext = S_R2;
            end
            S_R2: begin
                RA = 1; 
                RB = 1;
                StateNext = S_R3;
            end
            S_R3: begin
                RA = 1; 
                RB = 1; 
                RC = 1;
                StateNext = S_Off;
            end
            default: begin
                // All lights off
                StateNext = S_Off;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge Clk) begin
        if (Rst) State <= S_Off;
        else     State <= StateNext;
    end
    
endmodule

