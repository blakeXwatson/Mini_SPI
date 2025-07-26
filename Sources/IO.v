`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 06:20:40 PM
// Design Name: 
// Module Name: IO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux2_1 (sig0, sig1, select, sigOut);
    input sig0, sig1, select;
    output sigOut;
    assign sigOut = select ? sig1 : sig0;
endmodule



module BCD (num, digits);
    input [2:0] num;
    output [7:0] digits;
    
    assign digits[0] = ~num[2] & ~num[1] & ~num[0];
    assign digits[1] = ~num[2] & ~num[1] & num[0];
    assign digits[2] = ~num[2] & num[1] & ~num[0];
    assign digits[3] = ~num[2] & num[1] & num[0];
    assign digits[4] = num[2] & ~num[1] & ~num[0];
    assign digits[5] = num[2] & ~num[1] & num[0];
    assign digits[6] = num[2] & num[1] & ~num[0];
    assign digits[7] = num[2] & num[1] & num[0];
endmodule


module IO(sclk, cs, mosi, buffer);
    input sclk, cs, mosi;
    output [7:0] buffer;

    reg [2:0] counter = 3'b000;
    wire shift;
    wire clear;
    
    assign clear = 1'b1;
    assign shift = 1'b0;
        
    ShiftRegister #8 sr (shift, mosi, sclk, clear, buffer);

    always @(posedge sclk) begin
        if(cs==0) begin     
            if( counter == 3'd7 ) begin  // i feel like this should be a 16, not a 15...
                counter = 3'b000;
            end
            else begin
                counter = counter + 1'b1;
            end
        end
    end

endmodule
