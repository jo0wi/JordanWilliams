`timescale 1ns / 1ps

module tb_VGA_noSignal();

reg Clk = 0;
reg Rst = 0;

wire H_sync;
wire V_sync;
wire [11:0] RGB;


always #5 Clk = ~Clk;

top_VGAdisplay uut(Clk, Rst, H_sync, V_sync, RGB);

endmodule
