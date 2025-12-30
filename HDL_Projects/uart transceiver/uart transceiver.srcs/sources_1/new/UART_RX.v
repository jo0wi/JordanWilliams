`timescale 1ns / 1ps

module UART_RX(
    input Clk,
    input UART_sig,
    output RX_valid,
    output [7:0] RX_data
    );
    
    parameter CLKS_PER_BIT = 868; // for 100MHZ Clk and 115200 BAUD RATE
    
    // STATES
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter DATA = 2'b10;
    parameter STOP = 2'b11;
    
    reg [1:0] State = 0;
    reg [9:0] counter = 10'b0;
    reg [2:0] bit_index = 3'b0;
    reg [7:0] RX_reg = 8'b0;
    reg valid_reg = 1'b0;
    
    
    always @(posedge Clk) begin
        case(State)
            IDLE: begin
            
            counter <= 0;
            valid_reg <= 0;
            bit_index <= 0;
            
            if (UART_sig == 1'b0) State <= START;
            end
            START: begin
                if (counter == (CLKS_PER_BIT-1)/2) begin
                    if (UART_sig == 1'b0) begin
                        State <= DATA;
                        counter <= 0;
                    end else State <= IDLE;
                end else counter <= counter + 1;
            end
            DATA: begin
                if (bit_index < 8) begin
                    if (counter == CLKS_PER_BIT) begin
                        RX_reg [bit_index] <= UART_sig;
                        bit_index <= bit_index + 1;
                        counter <= 0;
                    end else counter <= counter + 1;
                end else begin
                    counter <= 0;
                    State <= STOP;
                    end
            end
            STOP: begin
                if ((counter == (CLKS_PER_BIT - 1)) && (UART_sig == 1)) begin
                    valid_reg <= 1'b1;
                    counter <= 0;
                    State <= IDLE;
                end else counter <= counter + 1;
            end
        endcase
    end
    
    assign RX_data = RX_reg;
    assign RX_valid = valid_reg;
    
endmodule
