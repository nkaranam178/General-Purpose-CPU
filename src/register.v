module register(q,d,clk,rst,en);
input [15:0] d;
input clk,rst;
output [15:0] q;
input en;


   dff_en dff_b0(.q(q[0]),.d(d[0]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b1(.q(q[1]),.d(d[1]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b2(.q(q[2]),.d(d[2]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b3(.q(q[3]),.d(d[3]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b4(.q(q[4]),.d(d[4]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b5(.q(q[5]),.d(d[5]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b6(.q(q[6]),.d(d[6]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b7(.q(q[7]),.d(d[7]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b8(.q(q[8]),.d(d[8]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b9(.q(q[9]),.d(d[9]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b10(.q(q[10]),.d(d[10]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b11(.q(q[11]),.d(d[11]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b12(.q(q[12]),.d(d[12]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b13(.q(q[13]),.d(d[13]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b14(.q(q[14]),.d(d[14]),.clk(clk),.rst(rst),.en(en));
   dff_en dff_b15(.q(q[15]),.d(d[15]),.clk(clk),.rst(rst),.en(en));

endmodule
