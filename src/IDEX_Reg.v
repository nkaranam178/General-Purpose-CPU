module IDEX_Reg(     //Outputs of IDEX
                     IDEX_rd_data1, 
		     IDEX_rd_data2,
		     IDEX_RegDst,
		     IDEX_SESel,
		     IDEX_RegWrite,
		     IDEX_DMemWrite,
                     IDEX_DMemEn,
		     IDEX_ALUSrc2,
		     IDEX_PCSrc,
		     IDEX_PCImm,
		     IDEX_MemToReg,
		     IDEX_DMemDump,
		     IDEX_Jump,
		     IDEX_WriteRegSel,
                     IDEX_instruction,
		     IDEX_increment,
                     
		     //Inputs of IDEX
                     rd_data1,
	             rd_data2,
		     RegDst,
		     SESel,
		     RegWrite,
		     DMemWrite,
                     DMemEn,
		     ALUSrc2,
		     PCSrc,
		     PCImm,
		     MemToReg,
		     DMemDump,
		     Jump,
                     clk,
		     rst,
		     IDEX_enable,
		     IFID_increment,
                     //Inputs from EX stage
		     IFID_instruction,
	             IFID_WriteRegSel,
		     flush
                     );
input flush;
input [2:0] IFID_WriteRegSel;
input [15:0] rd_data1,rd_data2,IFID_instruction,IFID_increment;
input [2:0] SESel;
input [1:0] RegDst;
input RegWrite,DMemWrite,DMemEn,ALUSrc2,PCSrc,PCImm,MemToReg,DMemDump,Jump,clk,rst,IDEX_enable;

output [15:0] IDEX_rd_data1,IDEX_rd_data2,IDEX_instruction,IDEX_increment;
output [2:0] IDEX_SESel;
output [1:0] IDEX_RegDst;
output IDEX_RegWrite,IDEX_DMemWrite,IDEX_DMemEn,IDEX_ALUSrc2,IDEX_PCSrc,IDEX_PCImm,IDEX_MemToReg,IDEX_DMemDump,IDEX_Jump;
output [2:0] IDEX_WriteRegSel;




register_3bit IDEX_WriteRegSel_Reg(.q(IDEX_WriteRegSel),.d(IFID_WriteRegSel),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_1bit IDEX_RegWrite_Reg(.q(IDEX_RegWrite),.d(RegWrite),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_1bit IDEX_DMemWrite_Reg(.q(IDEX_DMemWrite),.d(DMemWrite),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_1bit IDEX_DMemEn_Reg(.q(IDEX_DMemEn),.d(DMemEn),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_1bit IDEX_ALUSrc2_Reg(.q(IDEX_ALUSrc2),.d(ALUSrc2),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_1bit IDEX_PCSrc_Reg(.q(IDEX_PCSrc),.d(PCSrc),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_1bit IDEX_PCImm_Reg(.q(IDEX_PCImm),.d(PCImm),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_1bit IDEX_MemToReg_Reg(.q(IDEX_MemToReg),.d(MemToReg),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_1bit IDEX_DMemDump_Reg(.q(IDEX_DMemDump),.d(DMemDump),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_1bit IDEX_Jump_Reg(.q(IDEX_Jump),.d(Jump),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_3bit IDEX_SESel_Reg(.q(IDEX_SESel),.d(SESel),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register_2bit IDEX_RegDst_Reg(.q(IDEX_RegDst),.d(RegDst),.clk(clk),.rst(rst|flush),.en(IDEX_enable));

register IDEX_rd_data1_Reg(.q(IDEX_rd_data1),.d(rd_data1),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register IDEX_rd_data2_Reg(.q(IDEX_rd_data2),.d(rd_data2),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register IDEX_instruction_Reg(.q(IDEX_instruction),.d(IFID_instruction),.clk(clk),.rst(rst|flush),.en(IDEX_enable));
register IDEX_increment_Reg(.q(IDEX_increment),.d(IFID_increment),.clk(clk),.rst(rst|flush),.en(IDEX_enable));






endmodule
