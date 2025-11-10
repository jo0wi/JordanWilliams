`timescale 1ns / 1ps

module toggle_btn(
    input c_btn, clk,
    output LED
    );
 reg prev_btn = 1'b0;
 reg r_LED = 1'b0;
 wire debounced_btn;
 
debounce debouncer
    (.clk(clk),
     .c_btn(c_btn), 
     .fltr_btn(debounced_btn));
 
always @(posedge clk)
    begin
        prev_btn <= debounced_btn;
        if(debounced_btn == 1'b0 && prev_btn == 1'b1)
            begin
            r_LED <= ~r_LED;
            end
    end
         
   assign LED = r_LED;
  
endmodule
