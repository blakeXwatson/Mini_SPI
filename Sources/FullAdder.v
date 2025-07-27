`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Blake Watson
// 
// Create Date: 07/21/2025 06:19:17 PM
// Design Name: 
// Module Name: FullAdder
// Project Name: Mini_SPI
// Target Devices: xc7a35tftg256-1  ( Alchitry AU / Artix-7 )
// Tool Versions: 
// Description: Basic signed/unsigned operations modules.  IncrementerN is used by ComplementerN, which is used to drive test data for a physical device
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:  Have mercy, it's my 3rd time opening Vivado
// 
//////////////////////////////////////////////////////////////////////////////////



module FullAdder(
    input ci, 
    input xi, yi, 
    output si, ciNext
    );
    
    assign si = ci ^ (xi ^ yi);
    assign ciNext = ( yi & xi ) | ( ci & xi ) | ( ci & yi );
    
endmodule



module ShiftLN #(parameter n=8, parameter nMag=3) (a, mag, s);
    input [n-1:0] a;
    input [nMag-1:0] mag;
    output [n-1:0] s;
    wire [n-1:0] tmp;
    
    assign {tmp, s} = {a, a} << mag;
endmodule



module ShiftRN #(parameter n=8, parameter nMag=3) (a, mag, s);
    input [n-1:0] a;
    input [nMag-1:0] mag;
    output [n-1:0] s;
    wire [n-1:0] tmp;
    
    assign {tmp, s} = {a, a} >> mag;
endmodule


// 2-1 mux
module Mux2 (a, s, b);
    input [1:0] a;
    input s;
    output b;    
    assign b = s ? a[1] : a[0];
endmodule


module ReverseN #(parameter n=32)(i, r);
    input [n-1:0] i;
    output [n-1:0] r;
    
    genvar idx;
    generate
        for( idx=0; idx<n; idx=idx+1 )
        begin: reverseN
            assign r[ (n-1) - idx ] = i[idx];
        end
    endgenerate
    
endmodule



module RippleCarryAdderN #(parameter n=4) (c0, x, y, s, cn);    
    //parameter n=11;
    input c0;
    input [n-1:0] x, y;
    output [n-1:0] s;
    output cn;    

    // internal wire
    wire [n:0] c;

    // combinational logic on carries    
    assign c[0] = c0;

    // chaining the full adders together to make an N-bit adder
    generate
        for(genvar i=0; i<n; i=i+1)
        begin:addbit
            FullAdder faN ( c[i], x[i], y[i], s[i], c[i+1] );
        end
    endgenerate
    // there might be a sticky issue here, passing the carries into the next adder in parallel like this.

    // combinational logic on carries  
    assign cn = (&x) & (&y);
    
    // this one is tested, but i'm having weird problems with it in the flop testbench
    //assign cn = c[n-1];
        
endmodule



module RippleCarrySubtractorN #(parameter n=4) (c0, x, y, s, cn);    
    // s = x - y
    // x - y = x + (-1*y)
    
    //parameter n=11;
    input c0;
    input [n-1:0] x, y;
    output [n-1:0] s;
    output cn;    

    wire [n-1:0] yComplemented;

    // here, i'm doing:  yComplemented = (-1*b)
    ComplementerN #n comp (y, yComplemented);
    
    // and here i'm doing s = x + yComplemented
    RippleCarryAdderN #n adder (c0, x, yComplemented, s, cn);

endmodule



module IncrementerN #(parameter n=4) (a, s, cOut);
    // incrementer module.  n must be greater than 1
    //parameter n=11;
    input [n-1:0] a;
    output [n-1:0] s;
    output cOut;    
    // we don't need to consider the last bit here, only the ones leading up to it
    wire [n-2:0] ands; 
    genvar i;

    assign s[0] = ~a[0];
    assign s[1] = a[1] ^ a[0];
    assign ands[0] =  a[1] & a[0]; // ands[0] = and of first 2 bits
    assign cOut = ands[n-2];

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



module UnsignedMultiplierN #(parameter n=4) (m, q, p);
    // the implementation of a flop multiplier that i'm using implies that i should
    //   be finding and outputting a carry signal from this function.  need to do that!
    //parameter n = 4;
    input [n-1:0] m, q;
    output [(n*2)-1:0] p;

    assign p = m*q;
    
    /*
    
    i ended up using the built-in operator for this, but since learning is the goal,
      i tried it on my own first.  this was a pain to turn into a generic definition
      at first blush, but i'm sure it could be simplified.  
      this is the static definition of a 4-bit, carry-save, adder-array multiplier, not the generic
      

    wire [ ( (n-1)*n )-1 :0 ] carries;
    wire [ ( (n-1)*n )-1 :0 ] outputs;

    // n-1 rows of n adders
    // n*2 bits out
    
    // row 1
    // zeroes as inputs on the first and last adders
    FullAdder fa0 ( 1'b0,            ( m[1] & q[0] ), ( m[0] & q[1] ), outputs[0], carries[0] );
    FullAdder fa1 ( ( m[0] & q[2] ), ( m[2] & q[0] ), ( m[1] & q[1] ), outputs[1], carries[1] );
    FullAdder fa2 ( ( m[1] & q[2] ), ( m[3] & q[0] ), ( m[2] & q[1] ), outputs[2], carries[2] );
    FullAdder fa3 ( ( m[2] & q[2] ), 1'b0,            ( m[3] & q[1] ), outputs[3], carries[3] );
    
    // row 2
    FullAdder fa4 ( carries[0], outputs[1],      1'b0,            outputs[4], carries[4] );
    FullAdder fa5 ( carries[1], outputs[2],      ( m[0] & q[3] ), outputs[5], carries[5] );       
    FullAdder fa6 ( carries[2], outputs[3],      ( m[1] & q[3] ), outputs[6], carries[6] );       
    FullAdder fa7 ( carries[3], ( m[3] & q[2] ), ( m[2] & q[3] ), outputs[7], carries[7] );
    
    // row 3
    FullAdder fa8  ( 1'b0,        outputs[5],      carries[4], outputs[8],  carries[8]  );
    FullAdder fa9  ( carries[8],  outputs[6],      carries[5], outputs[9],  carries[9]  );
    FullAdder fa10 ( carries[9],  outputs[7],      carries[6], outputs[10], carries[10] );
    FullAdder fa11 ( carries[10], ( m[3] & q[3] ), carries[7], outputs[11], carries[11] );
    
    assign p[0] = m[0] & q[0];
    assign p[1] = outputs[0];
    assign p[2] = outputs[4];
    assign p[3] = outputs[8];
    assign p[4] = outputs[9];
    assign p[5] = outputs[10];
    assign p[6] = outputs[11];
    assign p[7] = carries[11];
    */

endmodule



module SignedMultiplierN #(parameter n=4) (m, q, p);
    //parameter n = 23;
    input [n-1:0] m, q;
    output [(n*2)-1:0] p;
    
    wire [n-1:0] mTmp, qTmp, mComp, qComp;
    wire [(n*2)-1:0] pTmp, pComp;
    
    wire mSign = m[n-1];
    wire qSign = q[n-1];
    wire pSign = mSign ^ qSign;
    
    // creating complemented versions of the multiplicand, multiplier, and unsigned product
    ComplementerN #n compM (m, mComp);
    ComplementerN #n compQ (q, qComp);
    ComplementerN #(n*2) compP (pTmp, pComp);
        
    // if either is negative, we're going to complement them to get the positive representation before multiplying
    assign mTmp = mSign ? mComp : m;
    assign qTmp = qSign ? qComp : q;

    // perform the multiplication like they're unsigned...
    assign pTmp = mTmp * qTmp;
    
    // if the product of the two numbers should have been negative, perform the 2s comp.
    //  else, just use the unsigned product as the result
    assign p = pSign ? pComp : pTmp;        

endmodule



// need to add an exception bit here, for divide by zero
module SignedDividerN #(parameter n=4) (m, q, p);
    //parameter n = 23;
    input [n-1:0] m, q;
    output [n-1:0] p;
     
    wire [n-1:0] mTmp, qTmp, mComp, qComp;
    wire [n-1:0] pTmp, pComp;
    
    wire mSign = m[n-1];
    wire qSign = q[n-1];
    wire pSign = mSign ^ qSign;
       
    // creating complemented versions of the multiplicand, multiplier, and unsigned product
    ComplementerN #n compM (m, mComp);
    ComplementerN #n compQ (q, qComp);
    ComplementerN #(n/2) compP (pTmp, pComp);
        
    // if either is negative, we're going to complement them to get the positive representation before multiplying
    assign mTmp = mSign ? mComp : m;
    assign qTmp = qSign ? qComp : q;

    // perform the division like they're unsigned...
    assign pTmp = mTmp / qTmp;
        
    // if the product of the two numbers should have been negative, perform the 2s comp.
    //  else, just use the unsigned product as the result
    assign p = pSign ? pComp : pTmp;        

endmodule



// need to add an exception bit here, for divide by zero
//  also, the remainder can probably stand to be smaller than the 
//  other values, here...  idk
module SignedDividerRN #(parameter n=4) (m, q, p, r);
    // honestly, this feels really inefficient.  i don't like having to use
    // both multiplication and subtraction to achieve the remainder result
    //  what i need to do is take a deeper look at the problem and see where
    //  things can be improved.
    
    input [n-1:0] m, q;
    output [n-1:0] p;
    output [n-1:0] r;
     
    wire [n-1:0] mTmp, qTmp, mComp, qComp;
    wire [n-1:0] pTmp, pComp;
    
    wire mSign = m[n-1];
    wire qSign = q[n-1];
    wire pSign = mSign ^ qSign;

    // used to get the remainder
    wire [n-1:0] reMultiply;
    wire rCarry;
       
    // creating complemented versions of the multiplicand, multiplier, and unsigned product
    ComplementerN #n compM (m, mComp);
    ComplementerN #n compQ (q, qComp);
    ComplementerN #(n/2) compP (pTmp, pComp);
        
    // if either is negative, we're going to complement them to get the positive representation before multiplying
    assign mTmp = mSign ? mComp : m;
    assign qTmp = qSign ? qComp : q;

    // perform the division like they're unsigned...
    assign pTmp = mTmp / qTmp;
    assign reMultiply=pTmp*qTmp;
    
    // c0, x, y, s, cn
    RippleCarrySubtractorN #n remainderSub (1'b0, mTmp, reMultiply, r, rCarry);
    
    // if the product of the two numbers should have been negative, perform the 2s comp.
    //  else, just use the unsigned product as the result
    assign p = pSign ? pComp : pTmp;        

endmodule






