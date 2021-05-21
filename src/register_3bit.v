module register_3bit( output [2:0] q,
                      input clk,
                      input rst,
                      input en,
                      input [2:0] d);

dff_en dff_bit0(.q(q[0]),.d(d[0]),.clk(clk),.rst(rst),.en(en));
dff_en dff_bit1(.q(q[1]),.d(d[1]),.clk(clk),.rst(rst),.en(en));
dff_en dff_bit2(.q(q[2]),.d(d[2]),.clk(clk),.rst(rst),.en(en));


endmodule
