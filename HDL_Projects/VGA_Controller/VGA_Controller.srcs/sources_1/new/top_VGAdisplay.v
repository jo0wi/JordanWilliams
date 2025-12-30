`timescale 1ns / 1ps


module top_VGAdisplay(
        input Clk,
        input Rst,
        output H_sync,
        output V_sync,
        output [11:0] RGB
    );
    wire Display_on;
    wire [9:0] x_pixel;
    wire [9:0] y_pixel;
    wire Pix_clk_en;
    wire [11:0] RGB_reg;
    reg [11:0] RGB_buff;

    VGA_Controller cnt(Clk, Rst, Display_on, H_sync, V_sync, x_pixel, y_pixel, Pix_clk_en);
    VGA_noSignal ns(Display_on, x_pixel, y_pixel, RGB_reg);
    
    always @(posedge Clk) begin
        RGB_buff <= RGB_reg;
    end
    
    assign RGB = RGB_buff;
endmodule
