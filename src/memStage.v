//////////////////////////////////////////////////////mem-stage module//////////////////////////////////////////////////////////////////////////////////////////////
module memStage(//Inputs
	        input clk,
          	input rst, 
		input DMemDump,
		input DMemWrite,
	       	input DMemEn,   //Inputs coming from control signal
                input [15:0] address,
	       	input [15:0] wt_data,
 
		//Outputs
                output Stall,
                output Done,
                output err, 
                output [15:0] read_data //Read_data is the data from d-mem, alu_out is result from execute stage (will be chosen in WB stage)
                );

// Cache DMem wires //
wire CacheHit;

// Unaligned DMem //

memory2c proc_Dmem(//Outputs
                   .data_out(read_data),

                   //Inputs
            	   .data_in(wt_data),
		   .addr(address),
		   .enable(DMemEn),
		   .wr(DMemWrite),
		   .createdump(DMemDump),
		   .clk(clk), 
		   .rst(rst)); //data mem

assign Stall = 1'b0;
assign Done  = 1'b1;


// Aligned DMem //
/*
memory2c_align aligned_Dmem(//Outputs
	                    .data_out(read_data), 
	                    .err(err),

			    //Inputs
		            .data_in(wt_data),
			    .addr(address),
			    .enable(DMemEn),
			    .wr(DMemWrite), 
			    .createdump(DMemDump), 
			    .clk(clk), 
			    .rst(rst) 
			   );

*/

//Cache memory//
/*
mem_system cache_Dmem(//Outputs
                      .DataOut(read_data),
                      .Done(Done),
                      .Stall(Stall),
                      .CacheHit(CacheHit),
                      .err(err),

                      //Inputs
                      .Addr(address),
                      .DataIn(wt_data),
                      .Rd(DMemEn),
                      .Wr(DMemWrite),
                      .createdump(DMemDump),
                      .clk(clk),
                      .rst(rst)
                     );

*/
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


