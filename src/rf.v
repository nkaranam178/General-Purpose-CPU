/*
   CS/ECE 552, Spring '19
   Homework #5, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module rf (
           // Outputs
           readData1, readData2, err,
           // Inputs
           clk, rst, readReg1Sel, readReg2Sel, writeRegSel, writeData, writeEn
           );
   
   input        clk, rst;
   input [2:0]  readReg1Sel;
   input [2:0]  readReg2Sel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] readData1;
   output [15:0] readData2;
   output        err;

   /* YOUR CODE HERE */
  wire [15:0] q0,q1,q2,q3,q4,q5,q6,q7;
  wire [15:0] d0,d1,d2,d3,d4,d5,d6,d7;
  wire [15:0] temp;

  //Write Logic
  assign d0 = writeEn? {(writeRegSel == 3'b000)? writeData: q0} : q0;
  assign d1 = writeEn? {(writeRegSel == 3'b001)? writeData: q1} : q1;
  assign d2 = writeEn? {(writeRegSel == 3'b010)? writeData: q2} : q2;
  assign d3 = writeEn? {(writeRegSel == 3'b011)? writeData: q3} : q3;
  assign d4 = writeEn? {(writeRegSel == 3'b100)? writeData: q4} : q4;
  assign d5 = writeEn? {(writeRegSel == 3'b101)? writeData: q5} : q5;
  assign d6 = writeEn? {(writeRegSel == 3'b110)? writeData: q6} : q6;
  assign d7 = writeEn? {(writeRegSel == 3'b111)? writeData: q7} : q7;
  
  register r0(.clk(clk),.rst(rst),.q(q0),.d(d0),.en(writeEn));
  register r1(.clk(clk),.rst(rst),.q(q1),.d(d1),.en(writeEn));
  register r2(.clk(clk),.rst(rst),.q(q2),.d(d2),.en(writeEn));
  register r3(.clk(clk),.rst(rst),.q(q3),.d(d3),.en(writeEn));
  register r4(.clk(clk),.rst(rst),.q(q4),.d(d4),.en(writeEn));
  register r5(.clk(clk),.rst(rst),.q(q5),.d(d5),.en(writeEn));
  register r6(.clk(clk),.rst(rst),.q(q6),.d(d6),.en(writeEn));
  register r7(.clk(clk),.rst(rst),.q(q7),.d(d7),.en(writeEn)); 
  
  //Read Logic
  assign readData1 = (readReg1Sel == 3'b000)? q0: 
		     (readReg1Sel == 3'b001)? q1:
    	             (readReg1Sel == 3'b010)? q2:
    	             (readReg1Sel == 3'b011)? q3:
    	             (readReg1Sel == 3'b100)? q4:
    	             (readReg1Sel == 3'b101)? q5:
    	             (readReg1Sel == 3'b110)? q6:
    	             (readReg1Sel == 3'b111)? q7:16'b0;

  assign readData2 = (readReg2Sel == 3'b000)? q0: 
		     (readReg2Sel == 3'b001)? q1:
    	             (readReg2Sel == 3'b010)? q2:
    	             (readReg2Sel == 3'b011)? q3:
    	             (readReg2Sel == 3'b100)? q4:
    	             (readReg2Sel == 3'b101)? q5:
    	             (readReg2Sel == 3'b110)? q6:
    	             (readReg2Sel == 3'b111)? q7:16'b0;   

//error logic


assign  temp = ^({^readData1,^writeData, ^readData2,^q0,^q1,^q2,^q3,^q4,^q5,^q6,^q7,^d0,^d1,^d2,^d3,^d4,^d5,^d6,^d7});    
assign err= (temp==1'bx) ? 1:0;    
endmodule
