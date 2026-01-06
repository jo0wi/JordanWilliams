`timescale 1ns / 1ps

// this top module, used with a serial terminal program, sends an ascii byte to the nexys a7
// displays it in hex on the seven segment display, and transmitts it back to the terminal

module top_UART_RXTX(
    input Clk,
    input Rst,
    input UART_TXD_IN,
    output UART_RXD_OUT,
    output A,
    output B, 
    output C,
    output D,
    output E,
    output F,
    output G,
    output [7:0]AN
    );
    
    wire ClkOut;
    wire [7:0] RX_data;
    wire RX_valid;
    wire TX_active;
    wire TX_line;
    
    ClkDiv div(.Clk(Clk), .DivRst(Rst), .ClkOut(ClkOut));
    hex_to_ssd disp(ClkOut, RX_data, RX_valid, A, B, C, D, E, F, G, AN);
    UART_RX rx(.Clk(Clk), .RX_line(UART_TXD_IN), .RX_valid(RX_valid), .RX_data(RX_data));
    UART_TX tx(.Clk(Clk), .Rst(Rst), .TX_valid(RX_valid),.TX_byte(RX_data), .TX_active(TX_active), .TX_line(TX_line), .TX_done());
    
    assign UART_RXD_OUT = TX_active ? TX_line : 1'b1;
    
endmodule
