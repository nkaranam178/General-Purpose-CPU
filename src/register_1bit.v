module register_1bit(input d,
                     input clk,
                     input rst,
                     input en,
                     output q);
dff_en dff_bit0(.q(q),.d(d),.clk(clk),.rst(rst),.en(en));
endmodule
