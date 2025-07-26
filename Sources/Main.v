`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 06:19:17 PM
// Design Name: 
// Module Name: Main
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


module Main(clk, sclk, cs, miso, mosi, led);
    input clk, sclk, cs, mosi;
    output miso;
    output [7:0] led;
    //wire [15:0] data;
    
    IO spi (sclk, cs, mosi, led);
    
    //assign led[7:0] = data[7:0];
    

endmodule
