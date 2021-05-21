//////////////////////////////////////////////////////control-stage module//////////////////////////////////////////////////////////////////////////////////////////////
module proc_control(input [15:0] instruction,input clk, input rst,
                    output err, output [1:0] RegDst, output [2:0] SESel, output RegWrite, output DMemWrite, output DMemEn,
                    output ALUSrc2, output PCSrc, output PCImm, output MemToReg, output DMemDump, output Jump
                    );

//Extra control signal logic


control control_unit(.OpCode(instruction[15:11]),.Funct(instruction[1:0]),.err(err),.RegDst(RegDst),.SESel(SESel),.RegWrite(RegWrite),.DMemWrite(DMemWrite),.DMemEn(DMemEn),.ALUSrc2(ALUSrc2),
                     .PCSrc(PCSrc),.PCImm(PCImm),.MemToReg(MemToReg),.DMemDump(DMemDump),.Jump(Jump),.rst(rst),.clk(clk));      

endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


