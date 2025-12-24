`timescale 1ns / 1ps

module tb_VGAcontroller();

reg Clk = 0;
reg Rst = 0;

wire Display_on;
wire H_sync;
wire V_sync;
wire [9:0] x_pixel;
wire [9:0] y_pixel;
wire Pix_clk_en;

always #5 Clk = ~Clk;

VGA_Controller uut(Clk, Rst, Display_on, H_sync, V_sync, x_pixel, y_pixel, Pix_clk_en);



endmodule
