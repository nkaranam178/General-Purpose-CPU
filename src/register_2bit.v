module register_2bit(input [1:0] d,
   	 	     input clk,
                     input rst,
                     input en,
                     output [1:0] q);

dff_en dff_bit0(.q(q[0]),.d(d[0]),.clk(clk),.rst(rst),.en(en));
dff_en dff_bit1(.q(q[1]),.d(d[1]),.clk(clk),.rst(rst),.en(en));
endmodule
