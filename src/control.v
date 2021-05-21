/*  CS/ECE 552, Spring '19
   Homework #6, Problem #1
  
   This module determines all of the control logic for the processor.
*/ 
 module control (/*AUTOARG*/
                // Outputs
                err,        
                RegDst,     //Done
                SESel,      //Done
                RegWrite,   //Done
                DMemWrite,  //Done
                DMemEn,     //Done
                ALUSrc2,    //Done
                PCSrc,      //Done
                PCImm,      //Done
                MemToReg,   //Done
                DMemDump,   //Done
                Jump,       //Done
                // Inputs
                OpCode,
                Funct,
                clk,rst
                );

   // inputs
   input [4:0]  OpCode;
   input [1:0]  Funct;
   input clk,rst; 
   // outputs
   output       err;
   output       RegWrite, DMemWrite, DMemEn, ALUSrc2, PCSrc, 
                PCImm, MemToReg, DMemDump, Jump;
   output [1:0] RegDst;
   output [2:0] SESel;
   wire rst_delay, rst_delay2;
   dff_en rst_delay_flop(.q(rst_delay),.d(rst),.clk(clk),.rst(1'b0),.en(1'b1)); 
//   dff_en rst_delay_flop2(.q(rst_delay2),.d(rst),.clk(clk),.rst(1'b0),.en(1'b1)); 
 
  /* YOUR CODE HERE */
  // wire RegDst0,RegDst1,RegDst3; 
   assign RegDst = (OpCode == 5'b11001 |    //BTR
	            OpCode == 5'b11011 |    //ADD 
	            OpCode == 5'b11010 |    //ROL
	            OpCode == 5'b11100 |    //SEQ
	            OpCode == 5'b11101 |    //SLT
	            OpCode == 5'b11110 |    //SLE
	            OpCode == 5'b11111 )? 2'b00:

 		   (OpCode == 5'b01000 |   //SUBI
	            OpCode == 5'b01001 |   //ADDI
	            OpCode == 5'b01010 |   //ANDNI
	            OpCode == 5'b01011 |   //XORI
	            OpCode == 5'b10100 |   //ROLI
	            OpCode == 5'b10101 |   //SLLI
	            OpCode == 5'b10110 |   //RORI
	            OpCode == 5'b10111 |   //SRLI
	            OpCode == 5'b10000 |   //ST
	            OpCode == 5'b10001 )? 2'b01: //LD

	           (OpCode == 5'b01100 |   //BNEZ
	            OpCode == 5'b01101 |   //BEQZ
	            OpCode == 5'b01110 |   //BLTZ
	            OpCode == 5'b01111 |   //BGEZ
	            OpCode == 5'b11000 |   //LBI
	            OpCode == 5'b10010 |   //SLBI
	            OpCode == 5'b10011 )? 2'b10:  //STU
		   
	           (OpCode == 5'b00110 |   //JAL
	            OpCode == 5'b00111 )?  2'b11: 2'b00;
/*   //   assign RegDst0 = (OpCode === 5'bx) ? 1'b0 : ~((OpCode[4] & OpCode[3]) & ~(~OpCode[2]&~OpCode[1]&~OpCode[0]));
 
 
   // ** TODO: OpCode[4]?
   assign RegDst1 = (OpCode === 5'bx) ? 1'b0 : ~(((OpCode[4] ^ OpCode[3]) & (OpCode[3] ^ OpCode[2]))|(OpCode === 5'b10000)|(OpCode === 5'b10001));
   assign RegDst3 = (OpCode === 5'bx) ? 1'b0 : ((OpCode === 5'b00110)|(OpCode === 5'b00111));
   assign RegDst = RegDst0? 2'b00:
                   RegDst1? 2'b01:
                   RegDst3? 2'b11: 2'b10; */
   assign RegWrite = (OpCode === 5'bx) ? 1'b0 :
	            ~(OpCode == 5'b00000|   //Hal
		      OpCode == 5'b00001|   //NOP
                      OpCode == 5'b10000|   //ST
                      OpCode == 5'b01100|   //BNEZ
		      OpCode == 5'b01101|   //BEQZ
		      OpCode == 5'b01110|   //BLTZ
                      OpCode == 5'b01111|   //BGEZ
		      OpCode == 5'b00100|   //J
		      OpCode == 5'b00101|   //JR
                      OpCode == 5'b00010|   //SiiC
		      OpCode == 5'b00011);   //RTI

		     // ~((~OpCode[4]&((OpCode[3]~^OpCode[2])|(OpCode[2]&~OpCode[1])))|(OpCode === 5'b10000));
   assign Jump = ((OpCode === 5'b00111)|(OpCode === 5'b00101));
   assign PCImm = ((OpCode === 5'b00100)|(OpCode === 5'b00110));
   assign DMemDump = (OpCode === 5'b00000)&~rst_delay;
   assign MemToReg = (OpCode === 5'b10001);
   assign PCSrc = (OpCode === 5'bx) ? 1'b0 : (~OpCode[4]&OpCode[2]);
   assign ALUSrc2 = ((OpCode === 5'bx) ? 1'b0 : ((OpCode [4] &OpCode[3]) & (OpCode != 5'b11000) & (OpCode != 5'b11001)));
   assign DMemEn = ((OpCode === 5'bx) ? 1'b0 : ((OpCode === 5'b10000) | (OpCode === 5'b10001) | (OpCode === 5'b10011)));
   assign DMemWrite = ((OpCode === 5'bx) ? 1'b0 : ((OpCode === 5'b10000) | (OpCode === 5'b10011)));
/* wire SESel_000,SESel_001,SESel_01X,SESel_10X,SESel_11X;
   assign SESel_000 = ((OpCode === 5'bx) ? 1'b0 : (~OpCode[4]&OpCode[3]&~OpCode[2]&OpCode[1]));
   assign SESel_001 = ((OpCode === 5'bx) ? 1'b0 : (OpCode[4]&~OpCode[3]&~OpCode[2]&OpCode[1]&~OpCode[0]));
   assign SESel_01X = (OpCode === 5'bx) ? 1'b0 : ~OpCode[2] &((~OpCode[4]&OpCode[3]&~OpCode[1])|(OpCode[4]&~OpCode[3]&(~OpCode[1]|OpCode[0])));
   assign SESel_10X = (OpCode === 5'bx) ? 1'b0 : ~(~OpCode[4]&((OpCode[3]&OpCode[2]) | (OpCode[2]&OpCode[0])))|(OpCode === 5'b11000)|(OpCode === 5'b01101);
   assign SESel_11X = (OpCode === 5'bx) ? 1'b0 : ~(~OpCode[4]&~OpCode[3]&OpCode[2]&~OpCode[0]);
   // ** TODO: Need to change x's to appropriate values
   assign SESel = SESel_000? 3'b000:
                  SESel_001? 3'b001:
                  SESel_01X? 3'b011:
                  SESel_10X? 3'b101: 3'b111; */
   assign SESel = (OpCode == 5'b00000|
                   OpCode == 5'b00001|
                   OpCode == 5'b01010|
                   OpCode == 5'b01011|
                   OpCode == 5'b10100|
                   OpCode == 5'b10101|
                   OpCode == 5'b10110|
                   OpCode == 5'b10111|
                   OpCode == 5'b11001|
                   OpCode == 5'b11011|
                   OpCode == 5'b11010|
                   OpCode == 5'b11100|
                   OpCode == 5'b11101|
                   OpCode == 5'b11110|
                   OpCode == 5'b11111|
                   OpCode == 5'b00010|
                   OpCode == 5'b00011)? 3'b000:

                  (OpCode == 5'b10010)? 3'b001:

                  (OpCode == 5'b01000|
                   OpCode == 5'b01001|
                   OpCode == 5'b10000|
                   OpCode == 5'b10001|
                   OpCode == 5'b10011)? 3'b011:

                  (OpCode == 5'b01100|
                   OpCode == 5'b01101|
                   OpCode == 5'b01110|
                   OpCode == 5'b01111|
                   OpCode == 5'b11000|
                   OpCode == 5'b00101|
                   OpCode == 5'b00111)? 3'b101:

                  (OpCode == 5'b00100|
                   OpCode == 5'b00110)? 3'b111: 3'b000;

     assign err = (((^OpCode[4:0])^(^Funct[1:0])) === 1'bx);
     //assign err = 1'b0;
endmodule


