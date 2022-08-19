module mod0(opcode,IM_d,RF_d1,clk,comp,regr,memloc);
input [3:0] opcode;
input [7:0] IM_d;
input [15:0] RF_d1;
input clk;
output reg comp=1'b1;
output reg [2:0] regr=3'b0;
output reg [15:0] memloc=16'b0;

reg [7:0] IMdreg=8'b0;
reg [15:0] memreg=16'b0;

always @(*)
begin
if((opcode==4'b1100)||(opcode==4'b1101))//lm,sm
begin
if(IMdreg==8'b0)
begin
memloc=RF_d1;
if(IM_d[7]==1'b1)
regr=3'b000;
else if(IM_d[6]==1'b1)
regr=3'b001;
else if(IM_d[5]==1'b1)
regr=3'b010;
else if(IM_d[4]==1'b1)
regr=3'b011;
else if(IM_d[3]==1'b1)
regr=3'b100;
else if(IM_d[2]==1'b1)
regr=3'b101;
else if(IM_d[1]==1'b1)
regr=3'b110;
else if(IM_d[0]==1'b1)
regr=3'b111;
else
regr=3'bxxx;
end

else//imdreg!=0
begin
memloc=memreg;
if(IMdreg[7]==1'b1)
regr=3'b000;
else if(IMdreg[6]==1'b1)
regr=3'b001;
else if(IMdreg[5]==1'b1)
regr=3'b010;
else if(IMdreg[4]==1'b1)
regr=3'b011;
else if(IMdreg[3]==1'b1)
regr=3'b100;
else if(IMdreg[2]==1'b1)
regr=3'b101;
else if(IMdreg[1]==1'b1)
regr=3'b110;
else if(IMdreg[0]==1'b1)
regr=3'b111;
else
regr=3'bxxx;
end


if((IMdreg==8'd1)||(IMdreg==8'd2)||(IMdreg==8'd4)||(IMdreg==8'd8)||(IMdreg==8'd16)||(IMdreg==8'd32)||(IMdreg==8'd64)||(IMdreg==8'd128)||(IM_d==8'd0)||(IM_d==8'd1)||(IM_d==8'd2)||(IM_d==8'd4)||(IM_d==8'd8)||(IM_d==8'd16)||(IM_d==8'd32)||(IM_d==8'd64)||(IM_d==8'd128))
comp=1'b1;
else
comp=1'b0;

end

else //any other instr
begin
regr=3'b000;
memloc=16'b0;
comp=1'b1;
end
end

always @(posedge clk)
begin
if((opcode==4'b1100)||(opcode==4'b1101))//lm,sm
begin
if((IMdreg==8'd1)||(IMdreg==8'd2)||(IMdreg==8'd4)||(IMdreg==8'd8)||(IMdreg==8'd16)||(IMdreg==8'd32)||(IMdreg==8'd64)||(IMdreg==8'd128)||(IM_d==8'd0))
IMdreg<=8'b0;
else if(IMdreg==8'b0)
begin
IMdreg<=IM_d[7:0];
IMdreg[3'b111-regr]<=1'b0;
memreg<=RF_d1+16'b1;
end
else if(IMdreg!=8'b0)
begin
IMdreg[3'b111-regr]<=1'b0;
memreg<=memreg+16'b1;
end
end
else
begin
IMdreg<=8'b0;
memreg<=16'b0;
end
end

endmodule














