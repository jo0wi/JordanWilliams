`timescale 1ns / 1ps

module tb_UART_TX();

reg Clk = 0;
reg rst = 0;
reg TX_valid = 0;
reg [7:0] TX_byte = 0;

wire TX_active;
wire TX_sig;
wire TX_done;

UART_TX uut(
    .Clk(Clk),
    .rst(rst),
    .TX_valid(TX_valid),
    .TX_byte(TX_byte),
    .TX_active(TX_active),
    .TX_sig(TX_sig),
    .TX_done(TX_done)
);

always #5 Clk = ~Clk; // 100MHz clock

initial begin
    rst = 1;
    #10;
    rst = 0;
    #10;
    
    // Send a byte
    TX_byte = 8'hAF;
    TX_valid = 1;
    @(posedge Clk);
    TX_valid = 0;
    
    // Wait for transmission to complete
    wait(TX_done);
    #100;
    
    // Send another byte
    TX_byte = 8'h55;
    TX_valid = 1;
    @(posedge Clk);
    TX_valid = 0;
    
    wait(TX_done);
    #100;
    
    $stop;
end

endmodule