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



module IO #(parameter lenIn=16, parameter lenOut=16) (sclk, cs, miso, mosi, buffer, bufferOut);

    input sclk, cs, mosi;
    input [lenOut-1:0] bufferOut;
    output miso;
    output [lenIn-1:0] buffer;

    reg misoReg;
    assign miso = misoReg;
    
    reg [7:0] counter = 8'd0;
    wire shift = ( counter > ( lenIn - 1 ) ) ? 1'b1 : 1'b0;
    wire clear = ~cs;
   

    ShiftRegister #lenIn sr (shift, mosi, sclk, clear, buffer);

       
    always @(posedge sclk) begin
        if(cs==0) begin
            if( counter == (lenIn + lenOut) -1 ) begin
                counter = 8'd0;
            end
            else begin
                counter = counter + 1'b1;
            end
        end
    end
    
    always @(negedge sclk) begin
        if( cs == 0 ) begin
            if( counter > ( lenIn - 1 ) ) begin
                misoReg = bufferOut[ ( ( lenIn + lenOut ) -1 ) - counter ];  // was counter - 16.  doing it this was to reverse the endianness
            end
        end
    end
    
    
endmodule
