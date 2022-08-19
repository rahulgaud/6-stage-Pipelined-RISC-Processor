module pp_tb1;
reg clk;
wire cy,z;
integer i;

processor_project p1(clk,cy,z);

initial clk=1'b0;

always #5 clk=~clk;

initial
begin
for(i=0;i<8;i=i+1)
p1.RF1.RF[i]=16'b0;
for(i=0;i<65536;i=i+1)
p1.IM1.IM[i]=16'b0;

p1.pc=16'b0;

p1.IM1.IM[0]=16'h3201;
p1.IM1.IM[1]=16'h0281;
p1.IM1.IM[2]=16'h07C2;


#2
for(i=0;i<32;i=i+1)
begin
$display("%d %d %d %d %d ",p1.pc,p1.RF1.RF[1],p1.RF1.RF[2],p1.RF1.RF[7],p1.RF1.RF[5]);
#10;
end
end
initial
begin
#300 $stop;
end

endmodule
