`timescale 1ns / 1ps

module VGA_noSignal(
    input Display_on,
    input [9:0] x_pixel,
    input [9:0] y_pixel,
    output reg [11:0] RGB
    );
    
    parameter RED = 12'h00F;
    parameter ORANGE = 12'h0AF;
    parameter YELLOW = 12'h0FF;
    parameter GREEN = 12'h0F0;
    parameter BLUE = 12'hF00;
    parameter INDIGO = 12'hFF0;
    parameter VIOLET = 12'hF0F;
    parameter WHITE = 12'hFFF;
    parameter BLACK = 12'h000;
    parameter PINK = 12'hAAF;
    parameter GRAY = 12'hAAA;
    
    wire red_on;
    wire orange_on;
    wire yellow_on;
    wire green_on;
    wire blue_on;
    wire indigo_on;
    wire violet_on;
    wire black_on;
    wire white_on;
    
    
    assign red_on = (x_pixel > 0) && (x_pixel <= 80) && (y_pixel < 460) && (y_pixel >= 20);
    assign orange_on = (x_pixel > 80) && (x_pixel <= 160) && (y_pixel < 460) && (y_pixel >= 20);
    assign yellow_on = (x_pixel > 160) && (x_pixel <= 240) && (y_pixel < 460) && (y_pixel >= 20);
    assign green_on = (x_pixel > 240) && (x_pixel <= 320) && (y_pixel < 460) && (y_pixel >= 20);
    assign blue_on = (x_pixel > 320) && (x_pixel <= 400) && (y_pixel < 460) && (y_pixel >= 20);
    assign indigo_on = (x_pixel > 400) && (x_pixel <= 480) && (y_pixel < 460) && (y_pixel >= 20);
    assign violet_on = (x_pixel > 480) && (x_pixel <= 560) && (y_pixel < 460) && (y_pixel >= 20);
    assign pink_on = (x_pixel > 560) && (x_pixel <= 640) && (y_pixel < 460) && (y_pixel >= 20);
    
    assign u_white_on = (x_pixel < 320 && y_pixel < 20);
    assign u_black_on = (x_pixel >= 320 && y_pixel < 20);
    assign l_black_on = (x_pixel < 320 && y_pixel >= 460);
    assign l_white_on = (x_pixel >= 320 && y_pixel >= 460);
    
    always @* begin
    if (~Display_on) RGB = BLACK;
    else
        if (red_on) RGB = RED;
        else if (orange_on) RGB = ORANGE;
        else if (yellow_on) RGB = YELLOW;
        else if (green_on) RGB = GREEN;
        else if (blue_on) RGB = BLUE;
        else if (indigo_on) RGB = INDIGO;
        else if (violet_on) RGB = VIOLET;
        else if (u_white_on || l_white_on) RGB = WHITE;
        else if (u_black_on || l_black_on) RGB = BLACK; 
        else if (pink_on) RGB = PINK;
    end
    
endmodule
