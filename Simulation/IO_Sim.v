`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Blake Watson
// 
// Create Date: 07/13/2025 04:25:29 PM
// Design Name: 
// Module Name: IO_Sim
// Project Name:  Mini_SPI
// Target Devices: 
// Tool Versions: 
// Description: Testbench for the SPI interface
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IO_Sim();
    reg clk;
    wire cs;
    wire miso, mosi;
    wire [15:0] buffer, bufferOut;
    
    reg mosiR;
    reg csR = 1'b0;
    reg [15:0] bufferR, bufferOutR, dataOut;
    
    integer counter = 0;

    assign cs = csR;
    assign mosi = mosiR;
    assign bufferOut = buffer;

    

    IO #(16, 16) spi (
        .sclk (clk),
        .cs (cs),
        .miso (miso),
        .mosi (mosi),
        .buffer (buffer),
        .bufferOut (bufferOut)
    );

    initial begin
        dataOut = 16'd0;
        clk = 0;

        
        forever begin
            #1 clk = ~clk;
        end        
    end

    
   always @(negedge clk) begin

        // Set cs to low, starting the SPI transaction, and send 16 bits to the DUT
        if(counter < 16 ) begin
            csR = 1'b0;
            // I reverse the endianness here
            mosiR = dataOut[15 - counter];
            counter = counter + 1;
        end

        // Read 16 bits back from the DUT
        else if( counter>15 && counter < 32 ) begin
            counter = counter + 1;
        end
        
        // Set cs to high, ending the SPI transaction.  I'm letting the clock go for another few ticks        
        else if(counter > 31 && counter < 40) begin
            csR = 1'b1;
            counter = counter + 1;
        end
        
        // Reset on the 41st cycle
        else if ( counter == 40 ) begin
            counter = 0;
            dataOut = dataOut + 1;
        end

   end


endmodule
