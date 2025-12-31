`timescale 1ns / 1ps

module tb_UART_TX();

reg Clk = 0;
reg Rst = 0;
reg TX_valid = 0;
reg [7:0] TX_byte = 0;

wire TX_active;
wire TX_sig;
wire TX_done;
wire [7:0] RX_data;

UART_RX rx_uut(.Clk(Clk), .UART_sig(UART_line), .RX_valid(RX_valid), .RX_data(RX_data));
UART_TX tx_uut(Clk, Rst, TX_valid, TX_byte, TX_active, TX_sig, TX_done);

assign UART_line = (TX_active) ? TX_sig : 1'b1;
always #5 Clk = ~Clk; // 100MHz clock

initial begin

    
    // Send a byte
    repeat(2)@(posedge Clk);
    TX_byte = 8'hAF;
    TX_valid = 1;
    @(posedge Clk);
    TX_valid = 0;
    
    // Wait for transmission to complete
    @(posedge RX_valid);
    repeat(10)@(posedge Clk);
end

endmodule