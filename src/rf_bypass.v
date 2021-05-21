/*
   CS/ECE 552, Spring '19
   Homework #5, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module rf_bypass (
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
wire [15:0] readDataWrapper1,readDataWrapper2;



rf iDUT(// Outputs
        .readData1(readDataWrapper1),
        .readData2(readDataWrapper2),
       	.err(err),
       
       	// Inputs
        .clk(clk),
	.rst(rst), 
	.readReg1Sel(readReg1Sel), 
	.readReg2Sel(readReg2Sel), 
	.writeRegSel(writeRegSel), 
	.writeData(writeData), 
	.writeEn(writeEn)
        );

assign readData1 = (readReg1Sel == writeRegSel)? {writeEn? writeData:readDataWrapper1 }: readDataWrapper1;
assign readData2 = (readReg2Sel == writeRegSel)? {writeEn? writeData:readDataWrapper2 }:readDataWrapper2;
endmodule 
