`timescale 1ns / 1ps

module VGA_Controller(
        input Clk,
        input Rst,
        output Display_on,
        output H_sync,
        output V_sync,
        output [9:0]x_coordinate,
        output [9:0]y_coordinate        
);

parameter   H_Display = 640,
            H_Frontporch = 48,
            H_Backporch = 16,
            H_Retrace = 96,
            H_MAX = H_Display + H_Frontporch + H_Backporch + H_Retrace - 1;
            
parameter   V_Display = 480,
            V_Frontporch = 10,
            V_Backporch = 33,
            V_Retrace = 2,
            V_MAX = V_Display + V_Frontporch + V_Backporch + V_Retrace - 1;    
            
                    
endmodule
