module Laser_FSM(
    input clk,
    input rst,
    input btn,
    output reg lzr
    );
    
    reg [2:0] count;
    reg active;
    
    always @(posedge clk) begin
        if (rst) begin
            count <= 3'b000;
            active <= 0;
            lzr <= 0;
        end 
        else if (btn && !active) begin
            active <= 1;
            count <= 3'b001;
            lzr <= 1;
        end 
        else if (active) begin
            if (count < 3'b100) begin
                count <= count + 1;
                lzr <= 1;
            end else begin
                active <= 0;
                count <= 3'b000;
                lzr <= 0;
            end
        end
    end
endmodule
