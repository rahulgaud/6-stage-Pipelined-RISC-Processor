module alu_pp(a,b,aluop,out,cy,z);
input [15:0] a,b;
input [1:0] aluop;
output reg [15:0] out;
output reg cy;
output z;

assign z=~|out;

always @(*)
begin
if(aluop==2'b00)
{cy,out}=a+b;
else if(aluop==2'b01) begin
out=~(a&b);
cy=1'b0;
end
else if(aluop==2'b10) begin
out=a-b;
cy=1'b0;
end
else begin
out=16'hxxxx;
cy=1'bx;
end
end

endmodule

