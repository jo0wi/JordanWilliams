`timescale 1ns / 1ps

module Lab2part_2(A,B,C,Y);

    input A,B,C;
    output Y;
    reg Y;
    
    always@(*)
    begin
        if (((~A&~B&~C)||(A&~B&~C)||(A&B&~C))==1)
            Y<=1;
        else
            Y<=0;
    end
endmodule
