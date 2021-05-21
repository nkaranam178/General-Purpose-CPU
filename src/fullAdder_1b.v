/*  Nikhil Karanam
    CS/ECE 552 Spring '19
    Homework #3, Problem 2
    
    a 1-bit full adder
*/
module fullAdder_1b(A, B, C_in, S, C_out);
    input  A, B;
    input  C_in;
    output S;
    output C_out;

    // YOUR CODE HERE
    wire w1,w2,w3;

    xor2 x1(.in1(A),.in2(B),.out(w1));         //w1 = A^B
    xor2 x2(.in1(C_in),.in2(w1),.out(S));      //S = (A^B)^C_in
    nand2 n1(.in1(A),.in2(B),.out(w2));         //w2 = !(A*B)
    nand2 n2(.in1(C_in),.in2(w1),.out(w3));     //w3 = !(C_in*(A^B))
    nand2 n3(.in1(w3),.in2(w2),.out(C_out));   //C_out = !(w2*w3) = (A*B) + (C_in*(A^B))
    	
endmodule
