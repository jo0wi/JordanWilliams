`timescale 1ns / 1ps

module VGA_TEST(
    input Clk,
    input Rst,
    input [11:0] SW,
    output H_sync,
    output V_sync,
    output [11:0] RGB
    );
    
    reg [11:0] RGB_reg;
    wire Display_on;
    wire Pix_clk_en;
    
    VGA_Controller uut(Clk, Rst, Display_on, H_sync, V_sync, x_pixel, y_pixel, Pix_clk_en);

    
    always @(posedge Pix_clk_en) begin
        if (Rst) RGB_reg <= 0;
        else RGB_reg <= SW;
    end
    
    assign RGB = (Display_on) ? RGB_reg : 12'b0;
endmodule
