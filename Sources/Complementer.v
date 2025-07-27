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
// Description: 1's and 2's complement modules and an incrementer.  Only used to drive sample output for the Arduino SPI test driver
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module IncrementerN #(parameter n=4) (a, s, cOut);
    // incrementer module.  n must be greater than 1

    input [n-1:0] a;
    output [n-1:0] s;
    output cOut;    

    wire [n-2:0] ands; 

    assign s[0] = ~a[0];
    assign s[1] = a[1] ^ a[0];
    assign ands[0] =  a[1] & a[0]; // ands[0] = and of first 2 bits
    assign cOut = ands[n-2];

    genvar i;

    // ands[1] = a[2] & a[1] & a[0], etc...
    generate
        for(i=1; i<n-1; i=i+1)
            begin: ands_cumulative
                assign ands[i] = a[i+1] & ands[i-1];
            end
    endgenerate
    
    generate
        for(i=2; i<n; i=i+1)
            begin: inc
                assign s[i] = a[i] ^  ands[i-2];
            end
    endgenerate

endmodule



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

