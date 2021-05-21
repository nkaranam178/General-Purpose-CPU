module EXMem_Reg(    //Outputs
                     EXMem_DMemDump,
		     EXMem_DMemWrite,
		     EXMem_DMemEn,
		     EXMem_new_PC,
		     EXMem_alu_result,
                     EXMem_rd_data2,
		     EXMem_MemToReg,
		     EXMem_WriteRegSel,
		     EXMem_RegWrite,
		     EXMem_RegDst,
                     EXMem_take_branch_or_jump,                   
                     EXMem_instruction,

                      //Inputs of EXMem
                     IDEX_instruction,
                     IDEX_new_PC,
	             IDEX_alu_result,
		     IDEX_RegWrite,
                     IDEX_rd_data2,
		     IDEX_DMemWrite,
		     IDEX_take_branch_or_jump,
                     IDEX_DMemEn,
		     IDEX_MemToReg,
		     IDEX_DMemDump,
		     IDEX_WriteRegSel,
		     IDEX_RegDst, 
                     clk,
		     rst,
		     en);

input [2:0] IDEX_WriteRegSel;
input clk,rst;
input [1:0] IDEX_RegDst;
input IDEX_RegWrite,IDEX_take_branch_or_jump,IDEX_DMemWrite,IDEX_DMemEn,IDEX_MemToReg,IDEX_DMemDump,en;
input [15:0] IDEX_new_PC,IDEX_alu_result,IDEX_rd_data2, IDEX_instruction;

output [2:0] EXMem_WriteRegSel;
output [1:0] EXMem_RegDst;
output EXMem_take_branch_or_jump,EXMem_RegWrite,EXMem_DMemDump,EXMem_DMemWrite,EXMem_DMemEn,EXMem_MemToReg; 
output [15:0] EXMem_alu_result, EXMem_new_PC, EXMem_rd_data2, EXMem_instruction;

register_3bit EXMem_WriteRegSel_Reg(.q(EXMem_WriteRegSel),.d(IDEX_WriteRegSel),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));
register_1bit EXMem_DMemWrite_Reg(.q(EXMem_DMemWrite),.d(IDEX_DMemWrite),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));
register_1bit EXMem_DMemDump_Reg(.q(EXMem_DMemDump),.d(IDEX_DMemDump),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));
register_1bit EXMem_DMemEn_Reg(.q(EXMem_DMemEn),.d(IDEX_DMemEn),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));
register_1bit EXMem_MemToReg_Reg(.q(EXMem_MemToReg),.d(IDEX_MemToReg),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));
register_1bit EXMem_RegWrite_Reg(.q(EXMem_RegWrite),.d(IDEX_RegWrite),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));
register_2bit EXMem_RegDst_Reg(.q(EXMem_RegDst),.d(IDEX_RegDst),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));
register_1bit EXMem_take_branch_or_jump_Reg(.q(EXMem_take_branch_or_jump),.d(IDEX_take_branch_or_jump),.clk(clk),.rst(rst),.en(en));

register EXMem_alu_result_Reg(.q(EXMem_alu_result),.d(IDEX_alu_result),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));
register EXMem_new_PC_Reg(.q(EXMem_new_PC),.d(IDEX_new_PC),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));
register EXMem_rd_data2_Reg(.q(EXMem_rd_data2),.d(IDEX_rd_data2),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));

//wire [15:0] EXMem_instruction_temp;
register EXMem_instruction_Reg(.q(EXMem_instruction),.d(IDEX_instruction),.clk(clk),.rst(rst|IDEX_take_branch_or_jump),.en(en));
//assign EXMem_instruction = (en)? EXMem_instruction_Temp: 16'h0800;


endmodule
