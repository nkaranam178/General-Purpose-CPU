module alu_ror_tb();
wire [15:0] Out;
reg [15:0] A,B;
reg [2:0] Op;
reg bool;
alu iDUT(.A(A), .B(B), .Cin(1'b0), .Op(Op), .invA(1'b0), .invB(1'b0), .sign(1'b0), .Out(Out), .Zero(), .Ofl());


initial begin
Op = 3'b010;
A = 16'h00ff;
B = 16'h0044;




end



endmodule

