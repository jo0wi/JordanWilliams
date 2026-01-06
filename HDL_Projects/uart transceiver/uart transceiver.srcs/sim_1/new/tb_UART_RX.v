`timescale 1ns / 1ps

module tb_UART_RX();

reg Clk = 0;
reg RX_line = 1;

wire RX_valid;
wire [7:0] RX_data;



task UART_SEND_BYTE;
    input [7:0] data_byte;
    integer i;
    
    begin
        //START BIT
        RX_line = 0; 
        #8680
        
        // SEND DATA BYTE
        for (i = 0; i < 8; i = i + 1) begin
            RX_line <= data_byte[i];
            #8680;
        end
        
        // STOP BIT
        RX_line <= 1;
        #8680;
    end
endtask

UART_RX uut(Clk, RX_line, RX_valid, RX_data);

always #5 Clk = ~Clk; //100MHz

initial begin
    @(posedge Clk);
    UART_SEND_BYTE(8'hAF);
    repeat(50)@(posedge Clk);
end
endmodule
