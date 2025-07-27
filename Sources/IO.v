`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Blake Watson
// 
// Create Date: 07/21/2025 06:20:40 PM
// Design Name: 
// Module Name: IO
// Project Name: Mini_SPI
// Target Devices: xc7a35tftg256-1 ( Alchitry AU / Artix-7 )
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



module IO(sclk, cs, miso, mosi, buffer, bufferOut);

    input sclk, cs, mosi;
    input [15:0] bufferOut;
    output miso;
    output [15:0] buffer;

    reg misoReg;
    assign miso = misoReg;
    
    reg [7:0] counter = 8'd0;
    wire shift = (counter>15) ? 1'b1 : 1'b0;
    wire clear = ~cs;
   

    ShiftRegister #16 sr (shift, mosi, sclk, clear, buffer);

       
    always @(posedge sclk) begin
        if(cs==0) begin
            if( counter == 8'd31 ) begin
                counter = 8'd0;
            end
            else begin
                counter = counter + 1'b1;
            end
        end
    end
    

    always @(negedge sclk) begin
        if(cs==0) begin
            if(counter>15) begin
                misoReg = bufferOut[31-counter];  // was counter - 16.  doing it this was to reverse the endianness
            end
        end
    end
    
    
endmodule
