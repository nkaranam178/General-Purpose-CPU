//////////////////////////////////////////////////////Execute module//////////////////////////////////////////////////////////////////////////////////////////////
module execute(//Inputs
	       input [15:0] instruction,
       	       input [15:0] incrementPC,
	       input [15:0] rd_data1,
	       input [15:0] rd_data2, //inputs from other stages
               input [2:0] SESel,
	       input ALUSrc2,
	       input PCSrc,
	       input Jump,
	       input PCImm,                            //Control signal inputs
               
	       //Outputs
	       output [15:0] alu_result,
	       output [15:0] new_PC,
	       output take_branch_or_jump); 

wire Zero,Ofl;
wire [15:0] Alu_A,Alu_B;
wire [15:0] extendedI;
//immediate extension logic
assign extendedI = (SESel == 3'b000)? {11'b0,instruction[4:0]}:
                   (SESel == 3'b001)? {8'b0,instruction[7:0]}:
                   (SESel[2:1] == 2'b01)? {{11{instruction[4]}},instruction[4:0]}:
                   (SESel[2:1] == 2'b10)? {{8{instruction[7]}},instruction[7:0]}:
                                          {{5{instruction[10]}},instruction[10:0]}; 
      
assign Alu_A = (instruction[15:11] == 5'b11000)? 16'b0:
               (instruction[15:11] == 5'b10010)? rd_data1<<8:
                rd_data1;      
assign Alu_B = (instruction[15:11] == 5'b01101)? 16'h0000:
                ~ALUSrc2? extendedI: rd_data2;
//Alu logic

//Alu OP control logic

wire [2:0] OP_code;
assign OP_code = (instruction[15:11] == 5'b11000)? 3'b100: //LBI instruction
            (instruction[15:11] == 5'b10010)? 3'b110: // SLBI instruction
            (instruction[15:11] == 5'b10000)? 3'b100: //ST instruction
	    (instruction[15:11] == 5'b10001)? 3'b100: //LD instruction
	    (instruction[15:11] == 5'b10011)? 3'b100: // STU instruction
            (instruction[15:11] == 5'b01101)? 3'b100: //BEQZ instruction
	    (instruction[15:13] == 3'b111)? 3'b100:
            (instruction[15]^instruction[14])? (
//Immediate alu instructions
            (instruction[13:11] == 3'b111)? 3'b011:
            (instruction[13:11] == 3'b110)? 3'b010:
            (instruction[13:11] == 3'b101)? 3'b001:
            (instruction[13:11] == 3'b100)? 3'b000:
            (instruction[13:11] == 3'b011)? 3'b111:
            (instruction[13:11] == 3'b010)? 3'b101:
            (instruction[13:11] == 3'b001)? 3'b100: 3'b100 ) :
//Non-immediate alu instructions
            (
            ({instruction[11],instruction[1:0]} == 3'b111)? 3'b101:
            ({instruction[11],instruction[1:0]} == 3'b110)? 3'b111:
            ({instruction[11],instruction[1:0]} == 3'b101)? 3'b100:
            ({instruction[11],instruction[1:0]} == 3'b100)? 3'b100:
            ({instruction[11],instruction[1:0]} == 3'b011)? 3'b011:
            ({instruction[11],instruction[1:0]} == 3'b010)? 3'b010:
            ({instruction[11],instruction[1:0]} == 3'b001)? 3'b001: 3'b000);

//Need to figure out C_in, invA,invB, sign        
wire C_in, invA, invB;// sign;
wire [15:0] alu_result_temp;
assign C_in = (instruction[15:11] == 5'b11100) | (instruction[15:11] == 5'b01000) | (instruction[15:11] == 5'b11011 & instruction[1:0] == 2'b01) | (instruction[15:13] == 3'b111 & ^instruction[12:11]);
assign invA = (instruction[15:11] == 5'b11100) | (instruction[15:11] == 5'b01000) | (instruction[15:13] == 3'b111 & ^instruction[12:11]) | ((instruction[15:11] == 5'b11011) & instruction[1:0] == 2'b01);
assign invB = (instruction[15:11] == 5'b01010) | ((instruction[15:11] == 5'b11011) & instruction[1:0] == 2'b11);

//assign alu_result_temp = 16'b1011;
//assign alu_result = alu_result_temp;
wire Cout;
alu exec_alu(.A(Alu_A),.B(Alu_B),.Cin(C_in),.Op(OP_code),.invA(invA),.invB(invB),.sign(1'b1),.Out(alu_result_temp),.Zero(Zero),.Ofl(Ofl),.Cout(Cout));

/// AlU logic  this for slt and slte 
wire b_gt_a, b_gte_a,C_out_slt,both_Positive, both_Negative;
wire [15:0]	Sum_slt;

// instatiate the addrer for

rca_16b DUT1(.A(~Alu_A),.B(Alu_B),.C_in(1'b1),.C_out(C_out_slt),.S(Sum_slt));
assign both_Positive = (~Alu_A[15] & ~Alu_B[15]);
assign both_Negative = (Alu_A[15] & Alu_B[15]);


assign b_gt_a = ((Alu_A[15] & (~Alu_B[15])) | ((both_Positive & ~Sum_slt[15] & (|Sum_slt)) | (both_Negative & ~Sum_slt[15] & (|Sum_slt)))); 
assign b_gte_a = (b_gt_a | (Alu_A == Alu_B));	

//BTR instruction case
//TODO: Change Alu_B > Alu_A for SLT and SLE cases//
assign alu_result = (instruction[15:11] == 5'b11001)? {rd_data1[0],rd_data1[1],rd_data1[2],rd_data1[3],rd_data1[4],rd_data1[5],
                                                      rd_data1[6],rd_data1[7],rd_data1[8],rd_data1[9],rd_data1[10],rd_data1[11],
                                                    rd_data1[12],rd_data1[13],rd_data1[14],rd_data1[15]}: 
                    (instruction[15:11] == 5'b11101)? {{15{1'b0}},(b_gt_a)}: 										  //SLT Case
		    (instruction[15:12] == 4'b0011) ? incrementPC:				    
		    (instruction[15:11] == 5'b11111)? {15'b0,Cout}:                                                                                               //SCO Case
		    (instruction[15:11] == 5'b11100)? {15'b0,Zero}:                                                                                               //SEQ Case
		    (instruction[15:11] == 5'b11110)?  {{15{1'b0}},(b_gte_a)}:                                                                             //SLE Case 
		    alu_result_temp;

//PC increment logic

wire take_branch;  //This checks the branch condition
assign take_branch = (~instruction[11]&~instruction[12]&~Zero)       |     //BNEZ
                     (instruction[11]&~instruction[12]&Zero)         |     //BEQZ
                     (~instruction[11]&instruction[12]&rd_data1[15]) |     //BLTZ
                     (instruction[11]&instruction[12]&~rd_data1[15]);      //BGEZ

assign take_branch_or_jump = (PCSrc&(take_branch| Jump | PCImm));

wire [15:0] Adder_A;
wire [15:0] Offset_PC;
assign Adder_A = Jump? rd_data1: incrementPC;    //If Jump, PC = PC + 2 + rs
rca_16b PC_adder(.A(Adder_A),.B(extendedI),.C_in(1'b0),.S(Offset_PC),.C_out());
assign new_PC = (take_branch_or_jump) ? Offset_PC: incrementPC;   //Choose the offset_PC if it's a jump instructin or if the branch condition is met

endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


