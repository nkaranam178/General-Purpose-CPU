//////////////////////////////////////////////////////Fetch module////////////////////////////////////////////////////////////////////////////////////////////////
// TODO: Fix IFID_increment - 2 //
module fetch(//Inputs
	     input [15:0] IFID_increment,
	     input MemWB_DMemDump,
	     input IFID_Stall,
             input [15:0] new_PC,
	     input EXMem_take_branch_or_jump, //Calculated offsetPC (for branch,jump,etc) Coming in from execute stage
             input clk,
	     input rst,
	     input halt_err,
             
	     //Outputs
	     output [15:0] instruction,
	     output [15:0] increment,
	     output err,
	     output Stall,
	     output Done,
	     output CacheHit
            );

wire [15:0] address,addressTemp;/* address_flopped;*/
wire PC_Cout;
wire [15:0] offset_PC,instruction_temp;
assign offset_PC = (EXMem_take_branch_or_jump)?new_PC:increment; 

//DMemDump should come from the writeback stage //

// PC Register //
register Program_counter(//Outputs                     
	                 .q(addressTemp),
	                 
	                 //Inputs 
	                 .d(offset_PC),
			 .clk(clk),
			 .rst(rst),
			 .en((( ~IFID_Stall & ~MemWB_DMemDump & ~Stall & Done) | EXMem_take_branch_or_jump) )
                        );                     

assign address = (EXMem_take_branch_or_jump)? new_PC:addressTemp;

rca_16b address_adder(//Inputs
	              .A(address),
	              .B(16'h0002),
		      .C_in(1'b0),
		      
		      //Outputs
		      .S(increment),
		      .C_out(PC_Cout));                   //increment = PC + 2
/*
register address_flop(.q(address_flopped),
                      .d(address),
                      .clk(clk),
                      .rst(rst),
                      .en((( ~IFID_Stall & ~MemWB_DMemDump & ~Stall & Done) | EXMem_take_branch_or_jump) )
                     );
*/
// Unaligned memory //
/*
memory2c proc_imem(//Outputs
	           .data_out(instruction), 
	           
	           //Inputs
		   .data_in(16'b0),
		   .addr(address),
		   .enable(1'b1),
		   .wr(1'b0),
		   .createdump(1'b0),
		   .clk(clk),
		   .rst(rst)
	           ); //I-mem

assign Stall = 1'b0;
assign Done  = 1'b1;
*/
// Aligned memory //
/*
memory2c_align aligned_imem(//Outputs
	                    .err(err),
	                    .data_out(instruction_temp),
	                    
			    //Inputs
			    .data_in(16'b0),
			    .addr(address),
			    .enable(1'b1),
			    .wr(1'b0),
			    .createdump(1'b0),
			    .clk(clk),
			    .rst(rst)
			    );

*/
//Stalling memory //
/*
stallmem stalling_imem(//Outputs
	               .DataOut(instruction_temp),
                       .Done(Done),
		       .Stall(Stall),
		       .CacheHit(CacheHit),
		       .err(err),
		       
		       //Inputs
		       .Addr(address),
		       .DataIn(16'b0),
		       .Rd(1'b1),
		       .Wr(1'b0),
		       .createdump(1'b0), 
		       .clk(clk),
		       .rst(rst));

*/
//Cache memory//

mem_system cache_imem(//Outputs
                      .DataOut(instruction_temp),
                      .Done(Done),
                      .Stall(Stall),
                      .CacheHit(CacheHit),
                      .err(err),

                      //Inputs
                      .Addr(address),
                      .DataIn(16'b0),
                      .Rd(1'b1),
                      .Wr(1'b0),
                      .createdump(1'b0),
                      .clk(clk),
                      .rst(rst)
                     );

assign instruction = (halt_err === 1'b1)? 16'h0000: (Stall | ~Done)? 16'h0800:instruction_temp;


endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
