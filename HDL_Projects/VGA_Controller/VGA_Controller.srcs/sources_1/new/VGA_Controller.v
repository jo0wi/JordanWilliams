`timescale 1ns / 1ps

module VGA_Controller(
        input Clk,
        input Rst,
        output Display_on,
        output H_sync,
        output V_sync,
        output [9:0]x_pixel,
        output [9:0]y_pixel        
);


parameter   H_Display = 640,
            H_Frontporch = 16,
            H_Backporch = 48,
            H_Retrace = 96,
            H_MAX = H_Display + H_Frontporch + H_Backporch + H_Retrace - 1;
            
parameter   V_Display = 480,
            V_Frontporch = 10,
            V_Backporch = 29,
            V_Retrace = 2,
            V_MAX = V_Display + V_Frontporch + V_Backporch + V_Retrace - 1;  

wire Clk_25MHz;
Clkgen #(.Clk_Speed(25_000_000)) Clkgen_25MHz(Clk, Rst, .Clk_Out(Clk_25MHz));

integer State = 0;
reg [9:0] H_counter, V_counter;

always @(posedge Clk_25MHz) begin
    if (Rst) H_counter <= 0;
    else if (H_counter >= H_MAX) H_counter <= 0;
    else H_counter <= H_counter + 1;

end

always @(posedge Clk_25MHz) begin
    if (Rst) V_counter <= 0;
    else if (H_counter >= H_MAX && V_counter >= V_MAX) V_counter <= 0;
    else if (H_counter >= H_MAX) V_counter <= V_counter + 1; 

end

assign Display_on = (H_counter <= H_Display && V_counter <= V_Display) ? 1 : 0;
assign H_sync = (H_counter >= (H_Display + H_Frontporch) && (H_counter <= H_Display + H_Frontporch + H_Retrace)) ? 1 : 0;
assign V_sync = (V_counter >= (V_Display + V_Frontporch) && (V_counter <= V_Display + V_Frontporch + V_Retrace)) ? 1 : 0;
assign x_pixel = H_counter;
assign y_pixel = V_counter;

endmodule
