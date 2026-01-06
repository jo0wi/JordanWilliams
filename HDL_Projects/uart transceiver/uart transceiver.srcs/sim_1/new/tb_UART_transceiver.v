`timescale 1ns / 1ps

module tb_UART_transceiver();

    reg Clk = 0;
    reg Rst = 0;
    reg UART_TXD_IN = 0;
    
    wire UART_RXD_OUT;
    wire A;
    wire B; 
    wire C;
    wire D;
    wire E;
    wire F;
    wire G;
    wire [7:0]AN;
    
    top_UART_RXTX uut(Clk,Rst,UART_TXD_IN,UART_RXD_OUT,A,B,C,D,E,F,G,AN);
    
    task UART_SEND_BYTE;
    input [7:0] data_byte;
    integer i;
    
    begin
        //START BIT
        UART_TXD_IN = 0; 
        #8680
        
        // SEND DATA BYTE
        for (i = 0; i < 8; i = i + 1) begin
            UART_TXD_IN <= data_byte[i];
            #8680;
        end
        
        // STOP BIT
        UART_TXD_IN <= 1;
        #8680;
    end
endtask

    always #5 Clk = ~Clk;
    
initial begin
    @(posedge Clk);
    UART_SEND_BYTE(8'hAF);
    repeat(50)@(posedge Clk);
end
endmodule
