module IFID_Reg(//Inputs
	        input clk,
	        input IFID_enable,
	       	input flush,
	       	input rst,
	       	input [15:0] instruction,
	       	input [15:0] increment,
	       	
		//Outputs
		output [15:0] IFID_instruction,
                output [15:0] IFID_increment);

//Stall conditions


wire [15:0] nextInst;
assign nextInst = (flush)?16'h0800:instruction;
//assign nextIncrement = (flush)? 16'h0000:increment;

register IFID_increment_Reg(.q(IFID_increment),.d(increment),.clk(clk),.rst(rst),.en(IFID_enable | increment === 16'h0002));  

register IFID_instruction_Reg(.q(IFID_instruction),.d(nextInst),.clk(clk),.rst(rst),.en(IFID_enable | flush | increment === 16'h0002 ));

endmodule
