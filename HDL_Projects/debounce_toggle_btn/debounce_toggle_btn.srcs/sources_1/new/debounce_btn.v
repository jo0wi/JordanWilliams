module debounce(input clk, c_btn,
           output fltr_btn);

reg [26:0] count; // 134_217_728 for 100 MHz
reg btn_state = 1'b0;
parameter cycle_limit = 1_000_000; // 1ms 

        always @(posedge clk)
            begin
                if (c_btn !== btn_state && count < cycle_limit)
                    count <= count + 1;
                else if (count == cycle_limit)
                    begin
                        count <= 0;
                        btn_state <= c_btn;
                    end
                else 
                    count <= 0;               
        end 
         
assign fltr_btn = btn_state;

endmodule