`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Blake Watson
// 
// Create Date: 07/21/2025 06:19:17 PM
// Design Name: 
// Module Name: Main
// Project Name: Mini_SPI
// Target Devices: xc7a35tftg256-1  ( Alchitry AU / Artix-7 )
// Tool Versions: 
// Description: Sample driver for IO module.  Complements uint16_t input and returns it over SPI.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Main(clk, sclk, cs, miso, mosi, led);
    input clk, sclk, cs, mosi;
    output miso;
    output [7:0] led;
    wire [15:0] data;
    wire [15:0] dataComplemented;
    
    IO spi (sclk, cs, miso,  mosi, data, dataComplemented);
    
    assign led[7:0] = data[7:0];
    ComplementerN #16 invert (data, dataComplemented);
    

endmodule
