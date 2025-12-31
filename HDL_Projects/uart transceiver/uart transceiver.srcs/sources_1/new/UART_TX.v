`timescale 1ns / 1ps

module UART_TX(
    input Clk,
    input Rst,  
    input TX_valid,
    input [7:0] TX_byte,
    output reg TX_active,
    output reg TX_sig,
    output reg TX_done
    );
    
    parameter CLKS_PER_BIT = 868;
    
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter DATA = 2'b10;
    parameter STOP = 2'b11;
    
    reg [1:0] State = 0;
    reg [9:0] counter = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] TX_byte_reg;

    
    always @(posedge Clk or posedge Rst) begin
        if (Rst) begin
            State <= IDLE;
            counter <= 0;
            bit_index <= 0;
            TX_active <= 0;
            TX_sig <= 1;
            TX_done <= 0;
        end else begin
            case(State) 
                IDLE: begin
                    TX_sig <= 1;
                    TX_done <= 0;
                    counter <= 0;
                    bit_index <= 0;
                    
                    if (TX_valid) begin
                        TX_active <= 1;
                        TX_byte_reg <= TX_byte; 
                        State <= START;    
                    end
                end
                START: begin
                    TX_sig <= 0;
                    
                    if (counter < CLKS_PER_BIT - 1) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 0;
                        State <= DATA;
                    end
                end
                DATA: begin
                    TX_sig <= TX_byte_reg[bit_index];
                    
                    if (counter < CLKS_PER_BIT - 1) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            bit_index <= 0;
                            State <= STOP;
                        end
                    end
                end
                STOP: begin
                    TX_sig <= 1; 
                    
                    if (counter < CLKS_PER_BIT - 1) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 0;
                        TX_active <= 0;
                        TX_done <= 1;
                        State <= IDLE;
                    end
                end
            endcase    
        end
    end
       
endmodule
