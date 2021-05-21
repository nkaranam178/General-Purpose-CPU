/* $Authors: Nikhil Karanam, Amit Mittal, Sean Cohen $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here */
   wire [15:0] instruction;
 /////////////////////////////////////////////////////////Control Signal outputs//////////////////////////////////////////////////////////////////////////////////
   wire IFID_RegWrite, IFID_DMemWrite, IFID_DMemEn, IFID_ALUSrc2, IFID_PCSrc,IFID_PCImm,IFID_MemToReg,IFID_DMemDump,IFID_Jump;
   wire [1:0] IFID_RegDst;
   wire [2:0] IFID_SESel;
   wire [2:0] IFID_WriteRegSel;
   wire [15:0] IFID_rd_data1,IFID_rd_data2;
   wire fetch_err, fetch_Done, fetch_Stall, fetch_CacheHit;
   wire [15:0] IFID_instruction, IFID_increment;
   wire control_err;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   wire [15:0] increment,new_PC,wt_data,rd_data1,rd_data2,alu_result,read_data;
   wire Zero,Ofl;
 
//IDEX wires   
   wire [15:0] IDEX_rd_data1,IDEX_rd_data2,IDEX_instruction,IDEX_increment;
   wire IDEX_RegWrite, IDEX_DMemWrite,IDEX_DMemEn,IDEX_ALUSrc2,IDEX_PCSrc,IDEX_PCImm,IDEX_MemToReg,IDEX_DMemDump,IDEX_Jump;
   wire [1:0] IDEX_RegDst;
   wire [2:0] IDEX_SESel;
   wire IDEX_enable;
   wire [2:0] IDEX_WriteRegSel;
   wire [15:0] IDEX_alu_result,IDEX_new_PC;  
   wire IDEX_take_branch_or_jump; 

//EXMem Wires
  wire EXMem_DMemDump,EXMem_DMemWrite,EXMem_DMemEn,EXMem_MemToReg,EXMem_RegWrite,EXMem_take_branch_or_jump;
  wire [15:0] EXMem_alu_result,EXMem_rd_data2;
  wire [2:0] EXMem_WriteRegSel;
  wire [1:0] EXMem_RegDst;
  wire [15:0] EXMem_read_data;
  wire [15:0] EXMem_new_PC;
  wire [15:0] EXMem_instruction;
  wire Mem_err;
  wire EXMem_DMem_Stall, EXMem_DMem_Done;

//MemWB Wires
  wire MemWB_RegWrite;
  wire [15:0] MemWB_read_data,MemWB_alu_out;
  wire MemWB_MemToReg;
  wire [2:0] MemWB_WriteRegSel;
  wire [1:0] MemWB_RegDst;
  wire [15:0] MemWB_wt_data;
  wire [15:0] MemWB_instruction;
  wire MemWB_DMemDump;
  wire MemWB_DMemEn;
 /////////////////////////////////////////////////////////////// Pipeline Stalling wires //////////////////////////////////////////////////////////////////////////////

   wire IFID_Stall;
   
   wire [1:0] IDEX_Stall_Condition;
   wire IDEX_Stall;
   wire IDEX_reset;
   
   wire EXMem_Stall;
   wire MemWB_Stall;

//////////////////////////////////////////////////////////////////// EX_to_EX FORWARDING LOGIC /////////////////////////////////////////////////////////////////////////////////////// 
  
   wire IDEX_EXMem_match1, IDEX_EXMem_match2;
   wire [15:0] Ex_to_Ex_Forward_R1;
   wire   EX_forward_R1;
   
   assign IDEX_EXMem_match1 = IDEX_instruction[10:8] == EXMem_WriteRegSel;
   assign IDEX_EXMem_match2 = IDEX_instruction[7:5]  == EXMem_WriteRegSel;

   assign EX_forward_R1 =    (IDEX_EXMem_match1) & ~( EXMem_DMemEn & ~(EXMem_instruction[15:11] == 5'b10011) )
                              & ~IDEX_Stall & ~(EXMem_instruction[15:12] == 4'b0000);

   assign Ex_to_Ex_Forward_R1 = (EX_forward_R1)? EXMem_alu_result:
                                                 IDEX_rd_data1;
   wire [15:0] Ex_to_Ex_Forward_R2;
   wire   EX_forward_R2;
   assign EX_forward_R2 =   (IDEX_EXMem_match2) & ~(EXMem_DMemEn & ~(EXMem_instruction[15:11] == 5'b10011)) 
                             & ~IDEX_Stall& ~(EXMem_instruction[15:12] == 4'b0000);

   assign Ex_to_Ex_Forward_R2 = (EX_forward_R2 )? EXMem_alu_result:
                                                 IDEX_rd_data2;

   wire EX_Forward;
   assign EX_Forward =   EX_forward_R1 | EX_forward_R2;   

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 


//////////////////////////////////////////////////////////////////// MEM_to_EX FORWARDING LOGIC ///////////////////////////////////////////////////////////////////////////// 
  
    
   wire [15:0] Mem_to_Ex_Forward_R1;
   wire   Mem_forward_R1;
   wire IDEX_MemWB_match1, IDEX_MemWB_match2;
   assign IDEX_MemWB_match1 = IDEX_instruction[10:8] == MemWB_WriteRegSel;
   assign IDEX_MemWB_match2 = IDEX_instruction[7:5]  == MemWB_WriteRegSel;   

   assign Mem_forward_R1 =   (IDEX_MemWB_match1) & ~( MemWB_DMemEn & ~MemWB_MemToReg & ~(MemWB_instruction[15:11] == 5'b10011))
                               & MemWB_RegWrite  & ~(MemWB_instruction[15:12] == 4'b0000);
   
   assign Mem_to_Ex_Forward_R1 = (Mem_forward_R1)?  MemWB_wt_data:
                                                   IDEX_rd_data1;
   wire [15:0] Mem_to_Ex_Forward_R2;
   wire   Mem_forward_R2;
   assign Mem_forward_R2 =   (IDEX_MemWB_match2) & ~( MemWB_DMemEn & ~MemWB_MemToReg & ~(MemWB_instruction[15:11] == 5'b10011) )
                             & MemWB_RegWrite & ~(MemWB_instruction[15:12] == 4'b0000);
   assign Mem_to_Ex_Forward_R2 = (Mem_forward_R2)?  MemWB_wt_data:
                                                   IDEX_rd_data2;
   wire Mem_Forward;
   assign Mem_Forward =    Mem_forward_R1 | Mem_forward_R2;   

   wire [15:0] IDEX_R1_Forward, IDEX_R2_Forward;
   assign IDEX_R1_Forward = (EX_forward_R1)?    Ex_to_Ex_Forward_R1:
                            (Mem_forward_R1)?   Mem_to_Ex_Forward_R1:
                                                IDEX_rd_data1;

   assign IDEX_R2_Forward = (EX_forward_R2)?   Ex_to_Ex_Forward_R2:
                            (Mem_forward_R2)?  Mem_to_Ex_Forward_R2:
                                               IDEX_rd_data2;
   

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

   
//////////////////////////////////////////////////////////////// PIPELINE STALLING LOGIC ///////////////////////////////////////////////////////////////////////////////////// 

   assign IFID_Stall = IDEX_Stall;

   wire IFID_source1_match;
   wire IFID_source2_match;
   assign IFID_IDEX_match1 = IFID_instruction[10:8] == IDEX_WriteRegSel;
   assign IFID_IDEX_match2 = IFID_instruction[7:5]  == IDEX_WriteRegSel;

   wire IFID_EXMem_match1;
   wire IFID_EXMem_match2;
   assign IFID_EXMem_match1 = IFID_instruction[10:8] == EXMem_WriteRegSel;
   assign IFID_EXMem_match2 = IFID_instruction[7:5]  == EXMem_WriteRegSel;

   assign IDEX_Stall =  (IDEX_EXMem_match1 | IDEX_EXMem_match2) & ( EXMem_DMemEn & EXMem_MemToReg) ;
                   
                    /*           //Wait 2 cycles
                                 ( (IFID_IDEX_match1) & ( IDEX_RegWrite) & (~EX_Forward | ~Mem_Forward) )|
                                 ( (IFID_IDEX_match2) & ( IDEX_RegWrite) & (~EX_Forward | ~Mem_Forward) )|

                                 //Wait 1 cycle 
                                 ((IFID_EXMem_match1) & ( EXMem_RegWrite) & (~EX_Forward | ~Mem_Forward) )|
                                 ((IFID_EXMem_match2) & ( EXMem_RegWrite) & (~EX_Forward | ~Mem_Forward) );
                    //             ( (IDEX_EXMem_match1 | IDEX_EXMem_match2) & EXMem_DMemEn & EXMem_MemToReg);
*/ 
  assign IDEX_reset = IDEX_Stall; 

  assign EXMem_Stall = MemWB_Stall;
  assign MemWB_Stall = 1'b0; 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 


////////////////////////////////////////////////////////////////////////////// err //////////////////////////////////////////////////////////////////////////////////////////

assign err = fetch_err | control_err | Mem_err; 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////// FETCH STAGE /////////////////////////////////////////////////////////////////////////////////////

  fetch proc_f(//Inputs
               .IFID_Stall(IFID_Stall), 
	       .IFID_increment(increment),
	       .new_PC(IDEX_new_PC),
	       .MemWB_DMemDump(MemWB_DMemDump),
	       .EXMem_take_branch_or_jump(IDEX_take_branch_or_jump),
	       .halt_err(err),
               .clk(clk),
	       .rst(rst),

               //Outputs
               .instruction(instruction),
	       .increment(increment),
               .err(fetch_err),
               .Stall(fetch_Stall),
               .Done(fetch_Done),
               .CacheHit(fetch_CacheHit)
              );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////// IF_ID pipeline register ////////////////////////////////////////////////////////////////////////

   IFID_Reg IF_to_ID(//Inputs of IFID
                     .instruction(instruction),
		     .increment(increment),
    	 	     .clk(clk),
		     .rst(rst /*| fetch_Stall*/),
		     .IFID_enable(~IFID_Stall /*& ~fetch_Stall*/ & (EXMem_MemToReg? (/*~EXMem_DMem_Stall &*/ EXMem_DMem_Done): 1'b1 ) ) ,
		     .flush(IDEX_take_branch_or_jump),
                      
		     //Outputs of IFID
                     .IFID_instruction(IFID_instruction),
	             .IFID_increment(IFID_increment)
	            );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////Control Unit///////////////////////////////////////////////////////////////////////////
   
   proc_control cont(//Inputs
                     .instruction(IFID_instruction),
		     .rst(rst),
		     .clk(clk),
                     
		     //Outputs
                     .err(control_err),
		     .RegDst(IFID_RegDst),
		     .SESel(IFID_SESel),
		     .RegWrite(IFID_RegWrite),
		     .DMemWrite(IFID_DMemWrite),
                     .DMemEn(IFID_DMemEn),
		     .ALUSrc2(IFID_ALUSrc2),
		     .PCSrc(IFID_PCSrc),
		     .PCImm(IFID_PCImm),
		     .MemToReg(IFID_MemToReg),
		     .DMemDump(IFID_DMemDump),
		     .Jump(IFID_Jump)
	            );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////// DECODE STAGE //////////////////////////////////////////////////////////////////////// 	

       decode decode(//Inputs
                     .MemWB_WriteRegSel(MemWB_WriteRegSel),
	             .writeEn(MemWB_RegWrite),
		     .RegDst(IFID_RegDst),
		     .wt_data(MemWB_wt_data),
		     .instruction(IFID_instruction),
		     .clk(clk),
		     .rst(rst),
		     .err(err),
                    
		     //Outputs
                     .IFID_WriteRegSel(IFID_WriteRegSel),
	             .rd_data1(IFID_rd_data1),
		     .rd_data2(IFID_rd_data2)
	            );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////ID_EX Pipeline Register/////////////////////////////////////////////////////////////////////

      IDEX_Reg ID_to_EX(//Outputs of IDEX
                     .IDEX_rd_data1(IDEX_rd_data1),
	             .IDEX_rd_data2(IDEX_rd_data2),
		     .IDEX_RegDst(IDEX_RegDst),
		     .IDEX_SESel(IDEX_SESel),
		     .IDEX_RegWrite(IDEX_RegWrite),
		     .IDEX_DMemWrite(IDEX_DMemWrite),
                     .IDEX_DMemEn(IDEX_DMemEn),
		     .IDEX_ALUSrc2(IDEX_ALUSrc2),
		     .IDEX_PCSrc(IDEX_PCSrc),
		     .IDEX_PCImm(IDEX_PCImm),
		     .IDEX_MemToReg(IDEX_MemToReg),
		     .IDEX_DMemDump(IDEX_DMemDump),
		     .IDEX_Jump(IDEX_Jump),
                     .IDEX_WriteRegSel(IDEX_WriteRegSel),
		     .IDEX_instruction(IDEX_instruction),
		     .IDEX_increment(IDEX_increment),
                     
		     //Inputs of IDEX
                     .rd_data1(IFID_rd_data1),
	             .rd_data2(IFID_rd_data2),
		     .RegDst(IFID_RegDst),
		     .SESel(IFID_SESel),
		     .RegWrite(IFID_RegWrite),
		     .DMemWrite(IFID_DMemWrite),
                     .DMemEn(IFID_DMemEn),
		     .ALUSrc2(IFID_ALUSrc2),
		     .PCSrc(IFID_PCSrc),
		     .PCImm(IFID_PCImm),
		     .MemToReg(IFID_MemToReg),
		     .DMemDump(IFID_DMemDump),
		     .Jump(IFID_Jump),
                     .clk(clk),
		     .rst(rst),
		     .IDEX_enable(~IDEX_Stall & (EXMem_MemToReg? (/*~EXMem_DMem_Stall &*/ EXMem_DMem_Done): 1'b1 ) ),
                     .IFID_instruction(IFID_instruction),
		     .IFID_WriteRegSel(IFID_WriteRegSel),
		     .IFID_increment(IFID_increment),
		     .flush(IDEX_take_branch_or_jump)
                      );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////// EXECUTE STAGE /////////////////////////////////////////////////////////////////////////////////////////

   execute proc_execute(//Inputs
                        .instruction(IDEX_instruction),
	                .incrementPC(IDEX_increment),
			.rd_data1(IDEX_R1_Forward),
			.rd_data2(IDEX_R2_Forward),
			.SESel(IDEX_SESel),
			.ALUSrc2(IDEX_ALUSrc2),
                        .PCSrc(IDEX_PCSrc),
			.Jump(IDEX_Jump),
			.PCImm(IDEX_PCImm),
                        
			//Outputs
                        .alu_result(IDEX_alu_result),
			.new_PC(IDEX_new_PC),
			.take_branch_or_jump(IDEX_take_branch_or_jump)
		       );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////EX_Mem Pipeline Register/////////////////////////////////////////////////////////////////////////////////////

    EXMem_Reg EX_to_Mem(//Outputs of EXMem
                        .EXMem_DMemDump(EXMem_DMemDump),
			.EXMem_DMemWrite(EXMem_DMemWrite),
			.EXMem_DMemEn(EXMem_DMemEn),
			.EXMem_new_PC(EXMem_new_PC),
			.EXMem_alu_result(EXMem_alu_result),
                        .EXMem_rd_data2(EXMem_rd_data2),
			.EXMem_MemToReg(EXMem_MemToReg),
			.EXMem_WriteRegSel(EXMem_WriteRegSel), 
			.EXMem_RegWrite(EXMem_RegWrite),
                        .EXMem_RegDst(EXMem_RegDst),
			.EXMem_take_branch_or_jump(EXMem_take_branch_or_jump),
                        .EXMem_instruction(EXMem_instruction),                      
 
		       	//Inputs of EXMem
                        .IDEX_instruction(IDEX_instruction),
                        .IDEX_new_PC(IDEX_new_PC),
			.IDEX_alu_result(IDEX_alu_result),
                        .IDEX_rd_data2(IDEX_R2_Forward),
			.IDEX_DMemWrite(IDEX_DMemWrite),
                        .IDEX_DMemEn(IDEX_DMemEn),
			.IDEX_MemToReg(IDEX_MemToReg),
			.IDEX_DMemDump(IDEX_DMemDump),
			.IDEX_WriteRegSel(IDEX_WriteRegSel),
			.IDEX_RegWrite(IDEX_RegWrite), 
                        .IDEX_RegDst(IDEX_RegDst),
			.clk(clk),
			.rst(rst | IDEX_reset),
			.en(~IDEX_Stall & (EXMem_MemToReg? (/*~EXMem_DMem_Stall &*/ EXMem_DMem_Done): 1'b1 ) ),
			.IDEX_take_branch_or_jump(1'b0 )
		       );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////// MEMSTAGE //////////////////////////////////////////////////////////////////////

   memStage proc_memStage(//Inputs
                          .clk(clk),
			  .rst(rst),
			  .DMemDump(EXMem_DMemDump),
			  .DMemWrite(EXMem_DMemWrite),
			  .DMemEn(EXMem_DMemEn),
			  .address(EXMem_alu_result),
			  .wt_data(EXMem_rd_data2),
                          
			  //Outputs
                          .Stall(EXMem_DMem_Stall),
                          .Done(EXMem_DMem_Done),
                          .read_data(EXMem_read_data),
			  .err(Mem_err)
			  );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////// MemWB Pipeline Register /////////////////////////////////////////////////////////////////////////////////

  MemWB_Reg Mem_to_WB( //Outputs of MemWB
                      .MemWB_read_data(MemWB_read_data),
		      .MemWB_alu_out(MemWB_alu_out),
		      .MemWB_MemToReg(MemWB_MemToReg),
		      .MemWB_WriteRegSel(MemWB_WriteRegSel), 
                      .MemWB_RegWrite(MemWB_RegWrite),
		      .MemWB_RegDst(MemWB_RegDst),
		      .MemWB_DMemDump(MemWB_DMemDump),
		      .MemWB_DMemEn(MemWB_DMemEn),
                      .MemWB_instruction(MemWB_instruction),                      

		      //Inputs of MemWB
                      .EXMem_instruction(EXMem_instruction),
                      .EXMem_read_data(EXMem_read_data),
		      .EXMem_MemToReg(EXMem_MemToReg),
		      .EXMem_alu_out(EXMem_alu_result),
		      .EXMem_WriteRegSel(EXMem_WriteRegSel),
                      .EXMem_RegDst(EXMem_RegDst),
		      .EXMem_RegWrite(EXMem_RegWrite),
		      .clk(clk),
		      .rst(rst),
		      .en( (EXMem_MemToReg? (/*~EXMem_DMem_Stall &*/ EXMem_DMem_Done): 1'b1 )),
		      .EXMem_DMemDump(EXMem_DMemDump),
		      .EXMem_DMemEn(EXMem_DMemEn)
	             );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////// WRITEBACK STAGE //////////////////////////////////////////////////////////////////////////////////// 
  
   writeback proc_writeback(//Inputs
                            .read_data(MemWB_read_data),
			    .alu_out(MemWB_alu_out),
			    .MemToReg(MemWB_MemToReg),
                            
			    //Outputs
                            .wt_data(MemWB_wt_data)
			   );

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

endmodule
// DUMMY LINE FOR REV CONTROL :0:

