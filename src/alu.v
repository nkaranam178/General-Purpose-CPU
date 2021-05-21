/*
    CS/ECE 552 Spring '19
    Homework #4, Problem 2

    A 16-bit ALU module.  It is designed to choose
    the correct operation to perform on 2 16-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the 16-bit result
    of the operation, as well as output a Zero bit and an Overflow
    (OFL) bit.
*/
module alu (A, B, Cin, Op, invA, invB, sign, Out, Zero, Ofl, Cout);

   // declare constant for size of inputs, outputs (N),
   // and operations (O)
   parameter    N = 16;
   parameter    O = 3;
   
   input [N-1:0] A;
   input [N-1:0] B;
   input         Cin;
   input [O-1:0] Op;
   input         invA;
   input         invB;
   input         sign;
   output[N-1:0] Out;
   output        Ofl;
   output        Zero;
   output        Cout;
   wire [15:0] wA,wB;
   assign wA = ({16{invA}}^A);
   assign wB = ({16{invB}}^B);
   

   /* YOUR CODE HERE */
wire [15:0] lshift1,lshift2,lshift3,res2;
wire [15:0] shift1,shift2,shift3,rotate_right,res3,res4,res5;

// inverting A and B




//assign A = sign ? w1:A;   //Change type A and B to signed
//assign B = sign ? w2:B;

//rotate right

assign shift1 = wB[0] ? {(~Op[0]&wA[0]),wA[15:1]} : wA[15:0];	            //Shift by 1 bit
assign shift2 = wB[1] ? {({2{~Op[0]}}&shift1[1:0]),shift1[15:2]} : shift1;           //Shift by 2 bits
assign shift3 = wB[2] ? {({4{~Op[0]}}&shift2[3:0]),shift2[15:4]} : shift2;           //Shift by 4 bits
assign rotate_right = wB[3] ? {({8{~Op[0]}}&shift3[7:0]),shift3[15:8]} : shift3;              //Shift by 8 bits


//Rotate or shift left

assign lshift1 = wB[0] ? {{wA[14:0]}, Op[0]? 1'b0:wA[15]} : wA[15:0];                           //Shift by 1 bit 
assign lshift2 = wB[1] ? {{lshift1[13:0]}, Op[0]? 2'b0:lshift1[15:14]} : lshift1;            //Shift by 2 bits
assign lshift3 = wB[2] ? {{lshift2[11:0]}, Op[0]? 4'b0:lshift2[15:12]} : lshift2;            //Shift by 4 bits
assign res2 = wB[3] ? {{lshift3[7:0]}, Op[0]? 8'b0:lshift3[15:8]} : lshift3;                    //Shift by 8 bits


assign res3 = Op[1] ? rotate_right : res2; //Choose between left and right shift

rca_16b DUT(.A(wA),.B(wB),.C_in(Cin),.S(res5),.C_out(Cout)); //A + B
assign res4 = Op[0] ? {Op[1]? (wA^wB):(wA&wB)}: {Op[1]?  (wA|wB): res5};

assign Out = Op[2] ? res4 : res3;

assign Zero = ~(|Out);
assign Ofl = sign ? (~(wA[15]^wB[15]) & (res5[15]^wA[15])) : Cout; //checking the overflow condition for signed or unsigned

endmodule
/*
//1-bit ripple carry adder
module fullAdder_1b(A, B, C_in, S, C_out);
    input  A, B;
    input  C_in;
    output S;
    output C_out;

    wire w1,w2,w3;
    assign w1 = A^B;
    assign S = C_in^w1;
    assign w2 = ~(A&B);
    assign w3 = ~(C_in&w1);
    assign C_out = ~(w3&w2);

    	
endmodule
*/
//4-bit ripple carry adder
/*
module rca_4b(A, B, C_in, S, C_out);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out;

    wire w1,w2,w3;
    fullAdder_1b fa0(.A(A[0]), .B(B[0]), .C_in(C_in), .S(S[0]), .C_out(w1));
    fullAdder_1b fa1(.A(A[1]), .B(B[1]), .C_in(w1), .S(S[1]), .C_out(w2));
    fullAdder_1b fa2(.A(A[2]), .B(B[2]), .C_in(w2), .S(S[2]), .C_out(w3));
    fullAdder_1b fa3(.A(A[3]), .B(B[3]), .C_in(w3), .S(S[3]), .C_out(C_out));

endmodule
*/
//16-bit ripple carry
/*
module rca_16b(A, B, C_in, S, C_out);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out;

    wire w1,w2,w3;
    rca_4b rca0(.A(A[3:0]), .B(B[3:0]), .C_in(C_in), .S(S[3:0]), .C_out(w1));
    rca_4b rca1(.A(A[7:4]), .B(B[7:4]), .C_in(w1), .S(S[7:4]), .C_out(w2));
    rca_4b rca2(.A(A[11:8]), .B(B[11:8]), .C_in(w2), .S(S[11:8]), .C_out(w3));
    rca_4b rca3(.A(A[15:12]), .B(B[15:12]), .C_in(w3), .S(S[15:12]), .C_out(C_out));

endmodule */
