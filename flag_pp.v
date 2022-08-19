module flag_pp(in,out,clk,en);
input in,clk,en;
output reg out;

always @(posedge clk)
begin
if(en)
out<=in;
end

endmodule
