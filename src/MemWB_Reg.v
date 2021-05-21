module MemWB_Reg( //Outputs of MemWB
                 MemWB_read_data,
		 MemWB_alu_out,
		 MemWB_MemToReg,
		 MemWB_WriteRegSel,
		 MemWB_RegWrite,
		 MemWB_RegDst,
		 MemWB_DMemDump,
		 MemWB_DMemEn,
                 MemWB_instruction,    
             
		 //Inputs of MemWB
                 EXMem_instruction,
                 EXMem_read_data,
	         EXMem_MemToReg,
		 EXMem_alu_out,
		 EXMem_WriteRegSel,
		 EXMem_RegWrite,
		 EXMem_RegDst,
		 EXMem_DMemDump,
		 EXMem_DMemEn,
                 clk,
		 rst,
		 en);

output [15:0] MemWB_read_data,MemWB_alu_out, MemWB_instruction;
output MemWB_MemToReg,MemWB_RegWrite,MemWB_DMemEn;
output [2:0] MemWB_WriteRegSel;
output [1:0] MemWB_RegDst;
output MemWB_DMemDump;

input [15:0] EXMem_read_data,EXMem_alu_out, EXMem_instruction;
input EXMem_MemToReg,EXMem_RegWrite,EXMem_DMemEn,clk,rst,en;
input [2:0] EXMem_WriteRegSel;
input [1:0] EXMem_RegDst;
input EXMem_DMemDump;

register_3bit MemWB_WriteRegSel_Reg(.q(MemWB_WriteRegSel),.d(EXMem_WriteRegSel),.clk(clk),.rst(rst),.en(en));

register MemWB_instruction_Reg(.q(MemWB_instruction),.d(EXMem_instruction),.clk(clk),.rst(rst),.en(en));
register MemWB_read_data_Reg(.q(MemWB_read_data),.d(EXMem_read_data),.clk(clk),.rst(rst),.en(en));
register MemWB_alu_out_Reg(.q(MemWB_alu_out),.d(EXMem_alu_out),.clk(clk),.rst(rst),.en(en));
register_1bit MemWB_MemToReg_Reg(.q(MemWB_MemToReg),.d(EXMem_MemToReg),.clk(clk),.rst(rst),.en(en));
register_1bit MemWB_RegWrite_Reg(.q(MemWB_RegWrite),.d(EXMem_RegWrite),.clk(clk),.rst(rst),.en(en));
register_2bit MemWB_RegDst_Reg(.q(MemWB_RegDst),.d(EXMem_RegDst),.clk(clk),.rst(rst),.en(en));
register_1bit MemWB_DMemDump_Reg(.q(MemWB_DMemDump),.d(EXMem_DMemDump),.clk(clk),.rst(rst),.en(en));
register_1bit MemWB_DMemEn_Reg(.q(MemWB_DMemEn),.d(EXMem_DMemEn),.clk(clk),.rst(rst),.en(en));

//wire MemWB_DMemDump_Delay;
//dff_en DMemDump_Delay(.q(MemWB_DMemDump_Delay),.d(MemWB_DMemDump),.clk(clk),.rst(rst),.en(en));

endmodule
