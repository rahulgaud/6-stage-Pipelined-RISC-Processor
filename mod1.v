module mod1(opcode,clk,RF_d1,comp1,regr1,memloc1);
input [3:0] opcode;
input clk;
input [15:0] RF_d1;
output reg comp1=1'b1;
output reg [2:0] regr1=3'b000;
output reg [15:0] memloc1=16'b0;

reg [15:0] memreg1=16'b0;

always @(*)
begin
if((opcode==4'b1110)||(opcode==4'b1111))//la, sa
begin
if(regr1==3'b0)
memloc1=RF_d1;
else
memloc1=memreg1;

if(regr1==3'b110)
comp1=1'b1;
else
comp1=1'b0;

end

else
begin
memloc1=16'b0;
comp1=1'b1;
end

end

always @(posedge clk)
begin
if((opcode==4'b1110)||(opcode==4'b1111))//la, sa
begin
if(regr1==3'b0)
begin
regr1<=regr1+1'b1;
memreg1<=RF_d1+1'b1;
end
else if(regr1<3'b110)
begin
regr1<=regr1+3'b1;
memreg1<=memreg1+16'b1;
end
else
begin
regr1<=3'b0;
memreg1<=16'b0;
end
end
else
begin
regr1<=3'b0;
memreg1<=16'b0;
end
end

endmodule







