module controller_pp(regr,IM_d,comp,comp1,cy,z,alu2_z,pcwrite,regwrite1,regwrite0,read,write,cywrite,zwrite,alu2srca,alu3srcb,DMsrcd,aluop,RFsrca2,RFsrcd3,RFsrcd4,alu2srcb,DMsrca,pcsrc,RFsrca3,branch);
input [15:0] IM_d;
input [2:0] regr;
input comp,comp1,cy,z,alu2_z;
output reg pcwrite,regwrite1,regwrite0,read,write,cywrite,zwrite,alu2srca,alu3srcb,DMsrcd,branch;
output reg [1:0] aluop,RFsrca2,RFsrcd3,RFsrcd4,alu2srcb,DMsrca;
output reg [2:0] pcsrc,RFsrca3;

always @(*)
begin
if((IM_d[15:12]==4'b0001)&&(IM_d[1:0]==2'b00))// ADD
begin
pcwrite=1'b1;
pcsrc=(IM_d[5:3]==3'b111)?3'b010:3'b000;
RFsrca2=2'b00;
RFsrca3=3'b000;
RFsrcd3=2'b00;
RFsrcd4=2'b00;
//regwrite0=(IM_d[5:3]==3'b111)?1'b0:1'b1;
regwrite0=1'b1;
regwrite1=1'b1;
alu2srca=1'b0;
alu2srcb=2'b00;
aluop=2'b00;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b1;
zwrite=1'b1;
branch=1'b0;
end
else if((IM_d[15:12]==4'b0010)&&(IM_d[1:0]==2'b00))// NDU
begin
pcwrite=1'b1;
pcsrc=(IM_d[5:3]==3'b111)?3'b010:3'b000;
RFsrca2=2'b00;
RFsrca3=3'b000;
RFsrcd3=2'b00;
RFsrcd4=2'b00;
//regwrite0=(IM_d[5:3]==3'b111)?1'b0:1'b1;
regwrite0=1'b1;
regwrite1=1'b1;
alu2srca=1'b0;
alu2srcb=2'b00;
aluop=2'b01;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b1;
branch=1'b0;
end
else if((IM_d[15:12]==4'b0001)&&(IM_d[1:0]==2'b10))// ADC
begin
pcwrite=1'b1;
pcsrc=(IM_d[5:3]==3'b111)?3'b010:3'b000;
RFsrca2=2'b00;
RFsrca3=3'b000;
RFsrcd3=2'b00;
RFsrcd4=2'b00;
//regwrite0=(IM_d[5:3]==3'b111)?1'b0:1'b1;
regwrite0=1'b1;
regwrite1=cy?1'b1:1'b0;
alu2srca=1'b0;
alu2srcb=2'b00;
aluop=2'b00;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b1;
zwrite=1'b1;
branch=1'b0;
end
else if((IM_d[15:12]==4'b0010)&&(IM_d[1:0]==2'b10))// NDC
begin
pcwrite=1'b1;
pcsrc=(IM_d[5:3]==3'b111)?3'b010:3'b000;
RFsrca2=2'b00;
RFsrca3=3'b000;
RFsrcd3=2'b00;
RFsrcd4=2'b00;
//regwrite0=(IM_d[5:3]==3'b111)?1'b0:1'b1
regwrite0=1'b1;
regwrite1=cy?1'b1:1'b0;
alu2srca=1'b0;
alu2srcb=2'b00;
aluop=2'b01;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b1;
branch=1'b0;

end
else if((IM_d[15:12]==4'b0001)&&(IM_d[1:0]==2'b01))// ADZ
begin
pcwrite=1'b1;
pcsrc=(IM_d[5:3]==3'b111)?3'b010:3'b000;
RFsrca2=2'b00;
RFsrca3=3'b000;
RFsrcd3=2'b00;
RFsrcd4=2'b00;
//regwrite0=(IM_d[5:3]==3'b111)?1'b0:1'b1;
regwrite0=1'b1;
regwrite1=z?1'b1:1'b0;
alu2srca=1'b0;
alu2srcb=2'b00;
aluop=2'b00;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b1;
zwrite=1'b1;
branch=1'b0;

end
else if((IM_d[15:12]==4'b0010)&&(IM_d[1:0]==2'b01))// NDC
begin
pcwrite=1'b1;
pcsrc=(IM_d[5:3]==3'b111)?3'b010:3'b000;
RFsrca2=2'b00;
RFsrca3=3'b000;
RFsrcd3=2'b00;
RFsrcd4=2'b00;
//regwrite0=(IM_d[5:3]==3'b111)?1'b0:1'b1
regwrite0=1'b1;
regwrite1=z?1'b1:1'b0;
alu2srca=1'b0;
alu2srcb=2'b00;
aluop=2'b01;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b1;
branch=1'b0;

end
else if((IM_d[15:12]==4'b0001)&&(IM_d[1:0]==2'b11))// ADL
begin
pcwrite=1'b1;
pcsrc=(IM_d[5:3]==3'b111)?3'b010:3'b000;
RFsrca2=2'b00;
RFsrca3=3'b000;
RFsrcd3=2'b00;
RFsrcd4=2'b00;
//regwrite0=(IM_d[5:3]==3'b111)?1'b0:1'b1
regwrite0=1'b1;
regwrite1=1'b1;
alu2srca=1'b0;
alu2srcb=2'b01;
aluop=2'b00;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b1;
zwrite=1'b1;
branch=1'b0;

end
else if(IM_d[15:12]==4'b0000)// ADI
begin
pcwrite=1'b1;
pcsrc=(IM_d[8:6]==3'b111)?3'b010:3'b000;
RFsrca2=2'bxx;
RFsrca3=3'b001;
RFsrcd3=2'b00;
RFsrcd4=2'b00;
//regwrite0=(IM_d[8:6]==3'b111)?1'b0:1'b1;
regwrite0=1'b1;
regwrite1=1'b1;
alu2srca=1'b0;
alu2srcb=2'b10;
aluop=2'b00;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b1;
zwrite=1'b1;
branch=1'b0;

end
else if(IM_d[15:12]==4'b0011)// LHI
begin
pcwrite=1'b1;
pcsrc=(IM_d[11:9]==3'b111)?3'b001:3'b000;
RFsrca2=2'bxx;
RFsrca3=3'b010;
RFsrcd3=2'b11;
RFsrcd4=2'b00;
//regwrite0=(IM_d[11:9]==3'b111)?1'b0:1'b1;
regwrite0=1'b1;
regwrite1=1'b1;
alu2srca=1'bx;
alu2srcb=2'bxx;
aluop=2'bxx;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;

end
else if(IM_d[15:12]==4'b0100)// LW
begin
pcwrite=1'b1;
pcsrc=(IM_d[11:9]==3'b111)?3'b011:3'b000;
RFsrca2=2'b00;
RFsrca3=3'b010;
RFsrcd3=2'b01;
RFsrcd4=2'b00;
//regwrite0=(IM_d[11:9]==3'b111)?1'b0:1'b1;
regwrite0=1'b1;
regwrite1=1'b1;
alu2srca=1'b1;
alu2srcb=2'b10;
aluop=2'b00;
DMsrca=2'b00;
DMsrcd=1'bx;
read=1'b1;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b1;
branch=1'b0;

end
else if(IM_d[15:12]==4'b0101)// SW
begin
pcwrite=1'b1;
pcsrc=3'b000;
RFsrca2=2'b00;
RFsrca3=3'bxxx;
RFsrcd3=2'bxx;
RFsrcd4=2'b00;
regwrite0=1'b1;
regwrite1=1'b0;
alu2srca=1'b1;
alu2srcb=2'b10;
aluop=2'b00;
DMsrca=2'b00;
DMsrcd=1'b0;
read=1'b0;
write=1'b1;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;

end
else if(IM_d[15:12]==4'b1100)// LM
begin
pcwrite=comp;
pcsrc=((IM_d[0]==1'b1)&(comp==1'b1))?3'b011:3'b000;
RFsrca2=2'bxx;
RFsrca3=3'b011;
RFsrcd3=2'b01;
RFsrcd4=2'b00;
//regwrite0=comp;
regwrite0=1'b1;
regwrite1=(IM_d[7:0]==8'b0)?1'b0:1'b1;
alu2srca=1'bx;
alu2srcb=2'bxx;
aluop=2'bxx;
DMsrca=2'b01;
DMsrcd=1'bx;
read=1'b1;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;

end
else if(IM_d[15:12]==4'b1101)// SM
begin
pcwrite=comp;
pcsrc=3'b000;
RFsrca2=2'b01;
RFsrca3=3'bxxx;
RFsrcd3=2'bxx;
RFsrcd4=2'b00;
//regwrite0=comp;
regwrite0=1'b1;
regwrite1=1'b0;
alu2srca=1'bx;
alu2srcb=2'bxx;
aluop=2'bxx;
DMsrca=2'b01;
DMsrcd=1'b1;
read=1'b0;
write=1'b1;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;

end
else if(IM_d[15:12]==4'b1110)// LA
begin
pcwrite=comp1;
pcsrc=3'b000;
RFsrca2=2'bxx;
RFsrca3=3'b100;
RFsrcd3=2'b01;
RFsrcd4=2'b00;
//regwrite0=comp1;
regwrite0=1'b1;
regwrite1=1'b1;
alu2srca=1'bx;
alu2srcb=2'bxx;
aluop=2'bxx;
DMsrca=2'b10;
DMsrcd=1'bx;
read=1'b1;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;

end
else if(IM_d[15:12]==4'b1111)// SA
begin
pcwrite=comp1;
pcsrc=3'b000;
RFsrca2=2'b10;
RFsrca3=3'bxxx;
RFsrcd3=2'bxx;
RFsrcd4=2'b00;
//regwrite0=comp1;
regwrite0=1'b1;
regwrite1=1'b0;
alu2srca=1'bx;
alu2srcb=2'bxx;
aluop=2'bxx;
DMsrca=2'b10;
DMsrcd=1'b1;
read=1'b0;
write=1'b1;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;

end
else if(IM_d[15:12]==4'b1000)// BEQ
begin
pcwrite=1'b1;
pcsrc=3'b100;
RFsrca2=2'b00;
RFsrca3=3'bxxx;
RFsrcd3=2'bxx;
RFsrcd4=2'b11;
regwrite0=1'b1;
regwrite1=1'b0;
alu2srca=1'b0;
alu2srcb=2'b00;
aluop=2'b10;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'b0;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b1;

end
else if(IM_d[15:12]==4'b1001)// JAL
begin
pcwrite=1'b1;
pcsrc=3'b100;
RFsrca2=2'bxx;
RFsrca3=3'b010;
RFsrcd3=2'b10;
RFsrcd4=2'b11;
regwrite0=1'b1;
regwrite1=1'b1;// dest cant be r7
alu2srca=1'bx;
alu2srcb=2'bxx;
aluop=2'bxx;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'b1;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;

end

else if(IM_d[15:12]==4'b1010)// JLR
begin
pcwrite=1'b1;
pcsrc=3'b101;
RFsrca2=2'b00;
RFsrca3=3'b010;
RFsrcd3=2'b10;
RFsrcd4=2'b10;
regwrite0=1'b1;
regwrite1=1'b1;// dest cant be r7
alu2srca=1'bx;
alu2srcb=2'bxx;
aluop=2'bxx;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;
end

else if(IM_d[15:12]==4'b1011)// JRI
begin
pcwrite=1'b1;
pcsrc=3'b010;
RFsrca2=2'bxx;
RFsrca3=3'bxxx;
RFsrcd3=2'bxx;
RFsrcd4=2'b01;
regwrite0=1'b1;
regwrite1=1'b0;
alu2srca=1'b0;
alu2srcb=2'b11;
aluop=2'b00;
DMsrca=2'bxx;
DMsrcd=1'bx;
read=1'b0;
write=1'b0;
alu3srcb=1'bx;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;

end

else if(IM_d[15:12]==4'b0110)// NOP
begin
pcwrite=1'b1;
pcsrc=3'b0;
RFsrca2=2'b0;
RFsrca3=3'b0;
RFsrcd3=2'b0;
RFsrcd4=2'b0;
regwrite0=1'b1;
regwrite1=1'b0;
alu2srca=1'b0;
alu2srcb=2'b0;
aluop=2'b00;
DMsrca=2'b0;
DMsrcd=1'b0;
read=1'b0;
write=1'b0;
alu3srcb=1'b0;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;

end

else
begin
pcwrite=1'b1;
pcsrc=3'b000;
RFsrca2=2'b00;
RFsrca3=3'b000;
RFsrcd3=2'b00;
RFsrcd4=2'b00;
regwrite0=1'b1;
regwrite1=1'b0;
alu2srca=1'b0;
alu2srcb=2'b00;
aluop=2'b00;
DMsrca=2'b00;
DMsrcd=1'b0;
read=1'b0;
write=1'b0;
alu3srcb=1'b0;
cywrite=1'b0;
zwrite=1'b0;
branch=1'b0;
end
end

endmodule
