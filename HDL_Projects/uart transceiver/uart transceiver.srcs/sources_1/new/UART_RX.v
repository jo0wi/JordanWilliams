`timescale 1ns / 1ps

// this module receives data transmitted over uart 
// at 115200 baud using 100Mhz clk 
module UART_RX(
    input Clk,
    input RX_line, // serial bits received
    output reg RX_valid = 1'b0, // uart data packet has been received 
    output reg [7:0] RX_data // received uart data byte
    );
    
    parameter CLKS_PER_BIT = 868; // for 100MHZ Clk and 115200 BAUD RATE
    
    // STATES
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter DATA = 2'b10;
    parameter STOP = 2'b11;
    
    reg [1:0] State = 0;
    reg [9:0] counter = 10'b0;
    reg [3:0] bit_index = 3'b0;
    reg [7:0] RX_reg = 8'b0;
    
    
    always @(posedge Clk) begin
        case(State)
            IDLE: begin // not receiving data
                counter <= 0;
                RX_valid <= 0;
                bit_index <= 0;
            
            if (RX_line == 1'b0) State <= START;
            end
            START: begin // checking for start bit received
                if (counter == (CLKS_PER_BIT-1)/2) begin // checking in the middle of signal 
                    if (RX_line == 1'b0) begin
                        State <= DATA;
                        counter <= 0;
                    end else State <= IDLE;
                end else counter <= counter + 1;
            end
            DATA: begin // receiving data bits
                if (bit_index < 8) begin
                    if (counter >= CLKS_PER_BIT) begin
                        RX_reg [bit_index] <= RX_line;
                        bit_index <= bit_index + 1;
                        counter <= 0;
                    end else counter <= counter + 1;
                end else begin
                    counter <= 0;
                    State <= STOP;
                    end
            end
            STOP: begin // checking for stop bit 
                if ((counter == (CLKS_PER_BIT - 1)) && (RX_line == 1)) begin
                    RX_valid <= 1'b1;
                    counter <= 0;
                    State <= IDLE;
                end else counter <= counter + 1;
            end
        endcase
    end
    
    always @(posedge RX_valid) RX_data <= RX_reg; // when complete byte is received output byte in RX_data
    
endmodule
