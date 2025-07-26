`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2025 06:08:03 PM
// Design Name: 
// Module Name: ShiftRegister
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


module DFF (clear, d, clk, q);
	input clear, d, clk;
	output q;
    reg qR;

    assign q = qR;

    always @(d, clk) begin

        if(clk==1'b0) begin
        
            if(clear==1'b1) begin
                qR = d;
            end
            else begin
                qR = 1'b0;
            end
            
        end
    end

endmodule
