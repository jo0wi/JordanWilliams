`timescale 1ns / 1ps

module tb_hex_to_ssd();

reg Clk = 0;
reg [7:0] RX_data;
reg RX_valid;

wire A;
wire B;
wire C;
wire D;
wire E;
wire F;
wire G;
wire [7:0]AN;

hex_to_ssd uut(Clk, RX_data, RX_valid, A, B, C, D, E, F, G, AN);

always #5 Clk = ~Clk;

initial begin
    @(posedge Clk);
    RX_data = 8'hAF;
    RX_valid = 1;
    @(posedge Clk);
    RX_valid = 0;
    repeat(10)@(posedge Clk);
end
endmodule
