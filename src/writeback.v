////////////////////////////////////////////////////WriteBack module//////////////////////////////////////////////////////////////////////////////////////////////
module writeback(//Inputs
	         input [15:0] read_data, 
	         input [15:0] alu_out,
		 input MemToReg,
                
		 //Outputs
		 output [15:0] wt_data);

assign wt_data =  MemToReg? read_data: alu_out;

endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


