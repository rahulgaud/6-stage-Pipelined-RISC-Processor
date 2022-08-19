module DM_pp(clk,addr,data,dataw,read,write);
input clk;
input [7:0] addr;
input [15:0] dataw;
input read,write;
output [15:0] data;

reg [15:0] DM [255:0];
integer i;

assign data=(read)?DM[addr]:16'hxxxx;

initial 
begin
for(i=0;i<255;i=i+1)
DM[i]=16'h0000;
//DM[0]=16'h0008;
//DM[1]=16'h0009;
//DM[2]=16'h0003;
//DM[3]=16'h0004;
//DM[4]=16'h001A;
//DM[5]=16'h0006;
//DM[6]=16'h0007;
//DM[7]=16'h0008;
//DM[8]=16'h0009;
//DM[9]=16'h000A;
//DM[10]=16'h000B;
end


always @(posedge clk)
begin
if(write)
DM[addr]<=dataw;
end

endmodule
