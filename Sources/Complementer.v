`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Blake Watson
// 
// Create Date: 07/21/2025 06:19:17 PM
// Design Name: 
// Module Name: Complementer
// Project Name: Mini_SPI
// Target Devices: xc7a35tftg256-1  ( Alchitry AU / Artix-7 )
// Tool Versions: 
// Description: 1's and 2's complement modules.  Only used to drive sample output for the Arduino SPI test driver
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Comp1s #(parameter n=4) (d, c);
    input [0:n-1] d;
    output [0:n-1] c;
    genvar i;

    generate
        begin: comp
            for(i=0;i<n;i=i+1) begin
                assign c[i] = ~d[i];
            end
        end
    endgenerate
    
endmodule


// this doesn't do anything with the sign, it simply complements the data in front of it
module ComplementerN #(parameter n=4) (d, c);
    input [n-1:0] d;
    output [n-1:0]c ;
    genvar i;

    wire [n-1:0] tmp;
    wire carry;

    // complement every bit...
    Comp1s #n comp(d, tmp);

    // and increment by 1
    IncrementerN #n inc (tmp, c, carry); 
    
endmodule

