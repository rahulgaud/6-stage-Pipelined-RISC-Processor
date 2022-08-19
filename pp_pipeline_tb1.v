module pp_pipeline_tb1;
reg clk;
wire cy,z;
integer i;

processor_project_pipeline p1(clk,cy,z);

initial clk=1'b0;

always #5 clk=~clk;

initial
begin
for(i=0;i<8;i=i+1)
p1.RF1.RF[i]=16'b0;
for(i=0;i<65536;i=i+1)
p1.IM1.IM[i]=16'b0;

p1.pc=16'b0;

p1.IM1.IM[0]=16'h0000;
p1.IM1.IM[1]=16'h0245;
p1.IM1.IM[2]=16'h0B46;
p1.IM1.IM[3]=16'h8204;
p1.IM1.IM[4]=16'h1550;
p1.IM1.IM[5]=16'h0001;
p1.IM1.IM[6]=16'h99FD;
p1.IM1.IM[7]=16'h9E00;
//p1.IM1.IM[8]=16'h1568;
//p1.IM1.IM[9]=16'h0D81;
//p1.IM1.IM[10]=16'h99FD;
//p1.IM1.IM[11]=16'h9E00;
//p1.IM1.IM[12]=16'h4301;
//p1.IM1.IM[13]=16'h0481;
//p1.IM1.IM[14]=16'h4D00;
//p1.IM1.IM[15]=16'h8683;
//p1.IM1.IM[16]=16'hA940;
//p1.IM1.IM[17]=16'h0241;
//p1.IM1.IM[18]=16'h9E00;

#2
for(i=0;i<2000;i=i+1)
begin
$display("p1: %d, R0: %d ,R1: %d ,R2: %d , R3: %d , R4: %d , R5: %d ,R6: %d ,R7:  %d ,stall_jump:  %d ,lookup[0]:   %h ,lookup[1]:  %h ,lookup[2]:  %h ,lookup[3]:  %h  ",p1.pc,p1.RF1.RF[0],p1.RF1.RF[1],p1.RF1.RF[2],p1.RF1.RF[3],p1.RF1.RF[4],p1.RF1.RF[5],p1.RF1.RF[6],p1.RF1.RF[7],p1.stall_jump,p1.lookup[0],p1.lookup[1],p1.lookup[2],p1.lookup[3]);
#10;
end
end
initial
begin
#200000 $stop;
end

endmodule
