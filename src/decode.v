//////////////////////////////////////////////////////Decode module//////////////////////////////////////////////////////////////////////////////////////////////
module decode(//Inputs
	      input writeEn,
	      input [1:0] RegDst,
	      input [2:0] MemWB_WriteRegSel,  //Control signal inputs
              input [15:0] wt_data,              //Data to be written to rf coming from writeback
              input [15:0] instruction,          //Instruction to be broken up to decode register select
              input clk,
	      input rst,
	      
	      //Outputs
	      output err,
	      output [2:0] IFID_WriteRegSel,
	      output [15:0] rd_data1,
	      output [15:0] rd_data2  //Actual data to be used in execute stage
              );
//regDST muxing logic

assign IFID_WriteRegSel = (RegDst == 2'b00)? instruction[4:2]:            //Behaviour as described by control logic hw
                          (RegDst == 2'b01)? instruction[7:5]:
        	          (RegDst == 2'b10)? instruction[10:8]: 
			                     3'b111;

//CHANGED rf from rf_bypass //

rf_bypass reg_file(//Outputs
	           .readData1(rd_data1),
                   .readData2(rd_data2),
		   .err(err),

		   //Inputs 
		   .clk(clk),
		   .rst(rst), 
		   .readReg1Sel(instruction[10:8]),
		   .readReg2Sel(instruction[7:5]),
		   .writeRegSel(MemWB_WriteRegSel),
		   .writeData(wt_data),
		   .writeEn(writeEn));

endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
