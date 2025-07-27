`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2025 04:25:29 PM
// Design Name: 
// Module Name: Servant_Sim
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


module ShiftRegister_Sim( );
    reg clk;
    reg preset = 1'b0;
    reg clear = 1'b1;
    reg d = 1'b0;
    wire qFF;
    wire [7:0] qSR;

    reg shift, serialIn;
    
    integer counter = 0;
    
    
    // module Servant( cs, sclk, miso, mosi, dataOut, dataIn );
    DFF ff (
        .clear (clear),
        .d (d),
        .clk (clk),
        .q (qFF)        
    );
     

    // module ShiftRegister(shift, serialIn, clk, clear, parallelIn, q);
    ShiftRegister #8 sr (
        .shift (shift),
        .serialIn (serialIn),
        .clk (clk),
        .clear (clear),
        .q (qSR)
    );



    initial begin
        shift=1;
        clk = 0;
        clear = 1;
        serialIn = 0;
        
        forever begin
            #1 clk = ~clk;
            
        end        
    end
        
   integer sent = 0;
    
   always @(posedge clk) begin
        if(counter==0) begin
            shift = 0;
            if(sent==0) begin
                serialIn = 1;
            end
            
           counter = counter + 1;
        end
        
        else if(counter>0 && counter <2 ) begin
            shift = 1;
            serialIn = 0;
            counter = counter + 1;

        end
        
        else if(counter == 2) begin
            counter = 0;
            sent = 1;
        end
                
   end


endmodule
