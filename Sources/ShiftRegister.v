`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Blake Watson
// 
// Create Date: 07/21/2025 06:19:17 PM
// Design Name: 
// Module Name: ShiftRegister
// Project Name: Mini_SPI
// Target Devices: xc7a35tftg256-1  ( Alchitry AU / Artix-7 )
// Tool Versions: 
// Description: Very basic D Flip-Flop and shift register modules, for use in IO.v
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ShiftRegister #(parameter n=8) (shift, serialIn, clk, clear, q);
    input shift, serialIn, clk, clear;
    output [n-1:0] q;
    reg [n-1:0] qR= {n {1'b0 } };
    assign q = qR;
    
    always @(posedge clk) begin
        if(clear==0) begin
            qR = {n{1'b0}};
        end
        else begin
            if(shift == 0 ) begin
                qR = qR << 1;
                qR[0] = serialIn;
            end
        end        
    end

endmodule
