`timescale 1ns / 1ps

module ReactionTimer(Clk, Rst, Start, LED, ReactionTime, Cheat, Slow, Wait, RandomValue, LCDUpdate, LCDAck);

    input Start, LCDAck, Clk, Rst;
	input [12:0] RandomValue;
    output reg [9:0] ReactionTime;
	output reg [7:0] LED;
    output reg Cheat, Slow, Wait;
	output reg LCDUpdate;
 
    parameter   S_0 = 0, //State 0
                S_1 = 1, //State 1
                S_2 = 2, //State 2
                S_3 = 3, //State 3
                S_4 = 4, //State 4
                S_5 = 5, //State 5
                S_6 = 6, //State 6
                Update_LCD = 7, //State 7
                WaitAck = 8; // State 8
    
    // INTERNAL REGISTERS            
    reg [9:0] Count = 0; // used to calculate ReactionTime
    reg [11:0] R_count = 0; // used to count to random gen value
    reg [12:0] RandomTemp; // used to latch the random gen value
    
    // regs used to debounce start button
    reg start_sync_0 = 0; // sync buffer
    reg start_sync_1 = 0; // sync buffer
    reg start_db = 0; // debounced level
    reg start_db_prev = 0; // previous debounced level 
    reg start_pulse = 0; // one clock pulse on rising edge
    
    parameter integer DEBOUNCE_TICKS = 10; // 1kHz ticks for debounce buffer
    reg [19:0] DebounceCnt = 0; // for counting to debounce ticks

    integer State = 0; // current state
    integer StateCnt = 0; // holds the next state after LCD is updated
        
        
    always @(posedge Clk) begin
        // DEBOUNCER AND SYNCRONIZER 
        // two flop synchronizer to "cross clock domains" from user input
        start_sync_0 <= Start;
        start_sync_1 <= start_sync_0;
        
        //require stable high for "DEBOUNCE_TICKS" number of ticks
        if (start_sync_1) begin
            if (DebounceCnt < DEBOUNCE_TICKS) DebounceCnt <= DebounceCnt + 1;
            if (DebounceCnt >= DEBOUNCE_TICKS) start_db <= 1;
        end else begin
            DebounceCnt <= 0;
            start_db <= 0;
        end
        // produce a single pulse on rising edge
        start_pulse <= (start_db & ~start_db_prev); // detect edges
        start_db_prev <= start_db;

        if (Rst) begin
            State <= S_0;
            // clear internal registers and debounce state on reset
            Count <= 0;
            R_count <= 0;
            DebounceCnt <= 0;
            start_sync_0 <= 0;
            start_sync_1 <= 0;
            start_db <= 0;
            start_db_prev <= 0;
            start_pulse <= 0;
        end
        else begin        
        case(State)
        S_0: begin //initialize start values
            Wait <= 0;
            R_count <= 0;
            Count <= 0; 
            LED <= 8'h00;
            Cheat <= 0;
            Slow <= 0; 
            ReactionTime <= 0;
            LCDUpdate <= 0; 
                
            if(start_pulse) begin 
                RandomTemp <= RandomValue; // latches in random value
                State <= S_1;
            end
        end
        S_1: begin // display wait 
            R_count <= 0;
            Count <= 0; 
            LED <= 8'h00;
            Cheat <= 0;
            Slow <= 0; 
            ReactionTime <= 0;
            Wait <= 1;
            StateCnt <= 2;
            State <= Update_LCD;
        end
        S_2: begin // count to random value
            if(R_count >= RandomTemp) begin
                Wait <= 0;
                StateCnt <= 3;
                State <= Update_LCD;
            end
            else if(start_pulse) begin // display cheat if start pressed in this state
                    Wait <= 0;
                    Cheat <= 1;
                    StateCnt <= 6;
                    State <= Update_LCD;                                     
                end
            else R_count <= R_count+1;
        end
        S_3: begin // light LEDs and increment reaction timer
            LED <= 8'hFF;
            Count <= Count +1;
            if(start_pulse) State <= S_4;
                
        end
        S_4: begin // calculate reaction time 
            LED <= 8'h00;
            ReactionTime <= Count << 1; // = count * 2
            State <= S_5;
        end
        S_5: begin
            if(ReactionTime < 500) begin 
                StateCnt <= 6;
                State <= Update_LCD;
            end
            if(ReactionTime > 500) begin // diaplay slow
                Slow <= 1;
                StateCnt <= 6;
                State <= Update_LCD;
            end
        end
        S_6: begin
            if(start_pulse) State <= S_1; // after running wait for start press
        end
        Update_LCD: begin // updates LCD 
            LCDUpdate <= 1;
            if (LCDAck) begin
                LCDUpdate <= 0;
                State <= WaitAck;
            end
        end
        WaitAck: begin // waits for LCDAck
            if (~LCDAck) State <= StateCnt;
        end
        endcase
    end
    end
  endmodule
