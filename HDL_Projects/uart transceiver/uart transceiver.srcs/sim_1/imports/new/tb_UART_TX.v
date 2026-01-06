`timescale 1ns / 1ps

module tb_UART_TX();

reg Clk = 0;
reg Rst = 0;
reg TX_valid = 0;
reg [7:0] TX_byte = 0;

wire TX_active;
wire TX_line;
wire TX_done;
wire [7:0] RX_data;

UART_RX rx_uut(.Clk(Clk), .RX_line(RX_line), .RX_valid(RX_valid), .RX_data(RX_data));
UART_TX tx_uut(Clk, Rst, TX_valid, TX_byte, TX_active, TX_line, TX_done);

assign RX_line = (TX_active) ? TX_line : 1'b1;
always #5 Clk = ~Clk; // 100MHz clock

initial begin

    
    // Send a byte
    repeat(2)@(posedge Clk);
    TX_byte = 8'hAF;
    TX_valid = 1;
    @(posedge Clk);
    TX_valid = 0;
    
    // Wait for first byte transmission to complete
    @(posedge RX_valid);
    repeat(10)@(posedge Clk);
    
    // Send second byte    
    @(posedge TX_done);
    repeat(2)@(posedge Clk);
    TX_byte = 8'h12;
    TX_valid = 1;
    @(posedge Clk);
    TX_valid = 0;
    
    //Wait for second byte transmission to complete
    @(posedge RX_valid);
    repeat(10)@(posedge Clk);
    
end

endmodule