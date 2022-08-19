module processor_project_pipeline(clk,cy,z);
input clk;
output cy,z;
reg [15:0] pc;
wire [15:0] pc_next;

wire pcwrite,regwrite1,regwrite0,read,write,cywrite,zwrite,alu2srca,alu3srcb,DMsrcd;
wire [1:0] aluop,RFsrca2,RFsrcd3,RFsrcd4,alu2srcb,DMsrca;
wire [2:0] pcsrc,RFsrca3;


wire [15:0] alu1out,alu2out,alu3out;
wire [15:0] alu2_a,alu2_b;
wire alu2_cy,alu2_z;
wire [15:0] alu3_b;
wire [15:0] IM_d;
wire [2:0] RF_a2,RF_a3;
wire [15:0] RF_d1,RF_d2,RF_d3,RF_d4;
wire [7:0] DM_a;
wire [15:0] DM_d,DM_dw;
wire comp,comp1;
wire [2:0] regr,regr1;
wire [15:0] memloc,memloc1;
wire [15:0] ALout;
wire [15:0] SE5out,SE8out;
wire stall_load,stall_jump;
wire [3:0] RF_d1_select,RF_d2_select;
wire [15:0] RF_d1_new,RF_d2_new;
wire cy_new,z_new;
wire [1:0] cy_select,z_select;
wire branch;
wire stall_jump_ex;


reg [15:0] IF_ID_pc=16'bx,IF_ID_alu1out=16'b0,IF_ID_IM_d=16'bx;// IF_ID stage reg

reg [15:0] ID_RR_pc=16'bx,ID_RR_alu1out=16'b0,ID_RR_IM_d=16'bx;// ID_RR stage reg

reg [15:0] RR_EX_RF_d1=16'b0,RR_EX_RF_d2=16'b0,RR_EX_SE5out=16'b0,RR_EX_SE8out=16'b0,RR_EX_ALout=16'b0,RR_EX_pc=16'bx,RR_EX_alu1out=16'b0,RR_EX_memloc=16'b0,RR_EX_memloc1=16'b0,RR_EX_IM_d=16'bx;
reg [2:0] RR_EX_regr=3'b0,RR_EX_regr1=3'b0;
reg RR_EX_comp,RR_EX_comp1,RR_EX_z_new=1'b0,RR_EX_cy_new=1'b0;// RR_EX stage reg=16'b0

reg [15:0] EX_MEM_alu2out=16'b0,EX_MEM_RF_d1=16'b0,EX_MEM_RF_d2=16'b0,EX_MEM_alu1out=16'b0,EX_MEM_ALout=16'b0,EX_MEM_IM_d=16'bx,EX_MEM_memloc=16'b0,EX_MEM_memloc1=16'b0;
reg [2:0] EX_MEM_regr=3'b0,EX_MEM_regr1=3'b0;
reg EX_MEM_cy,EX_MEM_z;
reg EX_MEM_comp,EX_MEM_comp1,EX_MEM_z_new=1'b0,EX_MEM_cy_new=1'b0;// EX_MEM stage reg

reg [15:0] MEM_WB_alu2out=16'b0,MEM_WB_alu1out=16'b0,MEM_WB_DM_d=16'b0,MEM_WB_ALout=16'b0,MEM_WB_IM_d=16'b0;
reg [2:0] MEM_WB_regr=3'b0,MEM_WB_regr1=3'b0;
reg MEM_WB_cy,MEM_WB_z;
reg MEM_WB_comp,MEM_WB_comp1,MEM_WB_z_new=1'b0,MEM_WB_cy_new=1'b0;// MEM_WB stage reg

// control signals


reg [2:0] RR_EX_pcsrc=3'b000,EX_MEM_pcsrc=3'b000;

reg [2:0] RR_EX_RFsrca3=3'b000,EX_MEM_RFsrca3=3'b000,MEM_WB_RFsrca3=3'b000;

reg [1:0] RR_EX_RFsrcd3=2'b0,EX_MEM_RFsrcd3=2'b0,MEM_WB_RFsrcd3=2'b0;

reg RR_EX_regwrite0=1'b0;

reg RR_EX_regwrite1=1'b0,EX_MEM_regwrite1=1'b0,MEM_WB_regwrite1=1'b0;

reg RR_EX_alu2srca=1'b0;

reg [1:0] RR_EX_alu2srcb=2'b00;

reg [1:0] RR_EX_aluop=2'b00;

reg [1:0] RR_EX_DMsrca=2'b00,EX_MEM_DMsrca=2'b00;

reg RR_EX_DMsrcd=1'b0,EX_MEM_DMsrcd=1'b0;

reg RR_EX_read=1'b0,EX_MEM_read=1'b0;

reg RR_EX_write=1'b0,EX_MEM_write=1'b0;

reg RR_EX_alu3srcb=1'b0;

reg RR_EX_cywrite=1'b0,EX_MEM_cywrite=1'b0,MEM_WB_cywrite=1'b0;

reg RR_EX_zwrite=1'b0,EX_MEM_zwrite=1'b0,MEM_WB_zwrite=1'b0;

reg RR_EX_branch=1'b0;

// branch prediction

reg [34:0] lookup [3:0];// 15:0 pc 31:16 bta 33:32 HB 34 full
integer i;

initial
begin
for(i=0;i<4;i=i+1) 
begin
lookup[i]=35'b0;

end
end

wire alu1_bta;
wire lookupwrite;
reg IF_ID_lookupwrite=1'b1,RR_EX_lookupwrite=1'b1;
wire [1:0] lookupindex;
reg [1:0] IF_ID_lookupindex=2'b00,RR_EX_lookupindex=2'b00,IF_ID_lookupindex1=2'b00;
reg [1:0] ID_RR_lookupindex=2'b0;
reg ID_RR_lookupwrite=1'b1;

assign lookupindex=(pc==lookup[0][15:0])?2'b00:
						 (pc==lookup[1][15:0])?2'b01:
						 (pc==lookup[2][15:0])?2'b10:
						 (pc==lookup[3][15:0])?2'b11:2'b00;
						 

assign alu1_bta=(((pc==lookup[0][15:0])&&(lookup[0][33]==1'b1))||((pc==lookup[1][15:0])&&(lookup[1][33]==1'b1))||((pc==lookup[2][15:0])&&(lookup[2][33]==1'b1))||((pc==lookup[3][15:0])&&(lookup[3][33]==1'b1)));

assign lookupwrite=~((pc==lookup[0][15:0])||(pc==lookup[1][15:0])||(pc==lookup[2][15:0])||(pc==lookup[3][15:0]));


// branch prediction reading end

wire [2:0] stall_jump_ext;

assign stall_jump_ext=(stall_jump==1'b1)?3'b000:3'b111;


assign pc_next=(EX_MEM_pcsrc==3'b011)?DM_d:
               ((RR_EX_pcsrc & stall_jump_ext)==3'b000)?((alu1_bta==1'b1)?lookup[lookupindex][31:16]:alu1out):
               ((RR_EX_pcsrc & stall_jump_ext)==3'b001)?RR_EX_ALout:
					((RR_EX_pcsrc & stall_jump_ext)==3'b010)?alu2out:
					((RR_EX_pcsrc & stall_jump_ext)==3'b100)?((((RR_EX_branch==1'b0)||(alu2_z==1'b1))==1'b1)?alu3out:alu1out):
					((RR_EX_pcsrc & stall_jump_ext)==3'b101)?RR_EX_RF_d2:alu1out;

assign RF_a2=(RFsrca2==2'b00)?ID_RR_IM_d[8:6]:
             (RFsrca2==2'b01)?regr:
				 (RFsrca2==2'b10)?regr1:3'bxxx;

assign RF_a3=(MEM_WB_RFsrca3==3'b000)?MEM_WB_IM_d[5:3]:
             (MEM_WB_RFsrca3==3'b001)?MEM_WB_IM_d[8:6]:
				 (MEM_WB_RFsrca3==3'b010)?MEM_WB_IM_d[11:9]:
				 (MEM_WB_RFsrca3==3'b011)?MEM_WB_regr:
				 (MEM_WB_RFsrca3==3'b100)?MEM_WB_regr1:3'bxxx;
				 
assign RF_d3=(MEM_WB_RFsrcd3==2'b00)?MEM_WB_alu2out:
             (MEM_WB_RFsrcd3==2'b01)?MEM_WB_DM_d:
				 (MEM_WB_RFsrcd3==2'b10)?MEM_WB_alu1out:
				 (MEM_WB_RFsrcd3==2'b11)?MEM_WB_ALout:16'bxxxx;
				 
//assign RF_d4=(RR_EX_RFsrcd4==2'b00)?pc:
//             (RR_EX_RFsrcd4==2'b01)?alu2out:
//				 (RR_EX_RFsrcd4==2'b10)?RR_EX_RF_d2:
//				 (RR_EX_RFsrcd4==2'b11)?(((~RR_EX_branch)||(alu2_z))?alu3out:pc):pc;

assign RF_d4=pc;

				 
assign alu2_a=(RR_EX_alu2srca==1'b1)?RR_EX_RF_d2:RR_EX_RF_d1;

assign alu2_b=(RR_EX_alu2srcb==2'b00)?RR_EX_RF_d2:
              (RR_EX_alu2srcb==2'b01)?(RR_EX_RF_d2<<1):
				  (RR_EX_alu2srcb==2'b10)?RR_EX_SE5out:
				  (RR_EX_alu2srcb==2'b11)?RR_EX_SE8out:16'bxxxx;
				  
assign alu3_b=(RR_EX_alu3srcb==1'b1)?RR_EX_SE8out:RR_EX_SE5out;

assign DM_a=(EX_MEM_DMsrca==2'b00)?EX_MEM_alu2out[7:0]:
            (EX_MEM_DMsrca==2'b01)?EX_MEM_memloc[7:0]:
				(EX_MEM_DMsrca==2'b10)?EX_MEM_memloc1[7:0]:8'hxx;
				
assign DM_dw=(EX_MEM_DMsrcd==1'b1)?EX_MEM_RF_d2:EX_MEM_RF_d1;

assign RF_d1_new=(RF_d1_select==4'b0001)?alu2out:
                 (RF_d1_select==4'b0010)?EX_MEM_alu2out:
					  (RF_d1_select==4'b0011)?MEM_WB_alu2out:
					  (RF_d1_select==4'b0100)?RR_EX_ALout:
					  (RF_d1_select==4'b0101)?EX_MEM_ALout:
					  (RF_d1_select==4'b0110)?MEM_WB_ALout:
					  (RF_d1_select==4'b0111)?DM_d:
					  (RF_d1_select==4'b1000)?MEM_WB_DM_d:
					  (RF_d1_select==4'b1001)?RR_EX_alu1out:
					  (RF_d1_select==4'b1010)?EX_MEM_alu1out:
					  (RF_d1_select==4'b1011)?MEM_WB_alu1out:
					  (RF_d1_select==4'b0000)?RF_d1:RF_d1;

assign RF_d2_new=(RF_d2_select==4'b0001)?alu2out:
                 (RF_d2_select==4'b0010)?EX_MEM_alu2out:
					  (RF_d2_select==4'b0011)?MEM_WB_alu2out:
					  (RF_d2_select==4'b0100)?RR_EX_ALout:
					  (RF_d2_select==4'b0101)?EX_MEM_ALout:
					  (RF_d2_select==4'b0110)?MEM_WB_ALout:
					  (RF_d2_select==4'b0111)?DM_d:
					  (RF_d2_select==4'b1000)?MEM_WB_DM_d:
					  (RF_d2_select==4'b1001)?RR_EX_alu1out:
					  (RF_d2_select==4'b1010)?EX_MEM_alu1out:
					  (RF_d2_select==4'b1011)?MEM_WB_alu1out:
					  (RF_d2_select==4'b0000)?RF_d2:RF_d2;
					  

assign cy_new=(cy_select==2'b01)?alu2_cy:
              (cy_select==2'b10)?EX_MEM_cy:
				  (cy_select==2'b11)?MEM_WB_cy:
				  (cy_select==2'b00)?cy:cy;

assign z_new=(z_select==2'b01)?alu2_z:
             (z_select==2'b10)?EX_MEM_z:
				 (z_select==2'b11)?MEM_WB_z:
				 (z_select==2'b00)?z:z;


// branch prediction writing

always @(*)// in ID stage
begin 
if(IF_ID_lookupwrite==1'b1) begin

if((IF_ID_IM_d[15:12]==4'b1000)||(IF_ID_IM_d[15:12]==4'b1001))// beq,jal
begin
if(lookup[0][34]==1'b0)// full=0
IF_ID_lookupindex=2'b00;
else if(lookup[1][34]==1'b0)// full=0
IF_ID_lookupindex=2'b01;
else if(lookup[2][34]==1'b0)// full=0
IF_ID_lookupindex<=2'b10;
else if(lookup[3][34]==1'b0)// full=0
IF_ID_lookupindex=2'b11;
else// all full
IF_ID_lookupindex=2'b00;
end

else 
IF_ID_lookupindex=2'b00;

end

else
IF_ID_lookupindex=IF_ID_lookupindex1;

end

always @(posedge clk)// in execute stage
begin
if(RR_EX_lookupwrite==1'b1) begin
if((RR_EX_IM_d[15:12]==4'b1000)||(RR_EX_IM_d[15:12]==4'b1001))// beq,jal
begin
lookup[RR_EX_lookupindex][31:16]<=alu3out;
lookup[RR_EX_lookupindex][33:32]<=((RR_EX_pcsrc==3'b100)&&((~RR_EX_branch)||(alu2_z)))?2'b11:2'b00;
lookup[RR_EX_lookupindex][15:0]<=RR_EX_pc;
lookup[RR_EX_lookupindex][34]<=1'b1;
end
end

else begin
if(((RR_EX_pcsrc==3'b000)&&(lookup[RR_EX_lookupindex][33:32]==2'b11))&&((RR_EX_IM_d[15:12]==4'b1000)||(RR_EX_IM_d[15:12]==4'b1001)))
lookup[RR_EX_lookupindex][33:32]<=2'b10;
else if(((RR_EX_pcsrc==3'b000)&&(lookup[RR_EX_lookupindex][33:32]==2'b10))&&((RR_EX_IM_d[15:12]==4'b1000)||(RR_EX_IM_d[15:12]==4'b1001)))
lookup[RR_EX_lookupindex][33:32]<=2'b00;
else if(((RR_EX_pcsrc==3'b000)&&(lookup[RR_EX_lookupindex][33:32]==2'b01))&&((RR_EX_IM_d[15:12]==4'b1000)||(RR_EX_IM_d[15:12]==4'b1001)))
lookup[RR_EX_lookupindex][33:32]<=2'b00;
else if((((RR_EX_pcsrc==3'b100)&&((~RR_EX_branch)||(alu2_z)))&&(lookup[RR_EX_lookupindex][33:32]==2'b00))&&((RR_EX_IM_d[15:12]==4'b1000)||(RR_EX_IM_d[15:12]==4'b1001)))
lookup[RR_EX_lookupindex][33:32]<=2'b01;
else if((((RR_EX_pcsrc==3'b100)&&((~RR_EX_branch)||(alu2_z)))&&(lookup[RR_EX_lookupindex][33:32]==2'b01))&&((RR_EX_IM_d[15:12]==4'b1000)||(RR_EX_IM_d[15:12]==4'b1001)))
lookup[RR_EX_lookupindex][33:32]<=2'b11;
else if((((RR_EX_pcsrc==3'b100)&&((~RR_EX_branch)||(alu2_z)))&&(lookup[RR_EX_lookupindex][33:32]==2'b10))&&((RR_EX_IM_d[15:12]==4'b1000)||(RR_EX_IM_d[15:12]==4'b1001)))
lookup[RR_EX_lookupindex][33:32]<=2'b11;
end

end


// branch prediction writing end


SE516 SE5(ID_RR_IM_d[5:0],SE5out);

SE816 SE8(ID_RR_IM_d[8:0],SE8out);

AL AL1(ID_RR_IM_d[8:0],ALout);

adder_pp alu1(pc,16'b1,alu1out);

alu_pp alu2(alu2_a,alu2_b,RR_EX_aluop,alu2out,alu2_cy,alu2_z);

adder_pp alu3(RR_EX_pc,alu3_b,alu3out);

IM_pp IM1(pc,IM_d);

RF_pp RF1(ID_RR_IM_d[11:9],RF_a2,RF_a3,RF_d1,RF_d2,RF_d3,RF_d4,clk,MEM_WB_regwrite1,RR_EX_regwrite0);

DM_pp DM1(clk,DM_a,DM_d,DM_dw,EX_MEM_read,EX_MEM_write);

flag_pp cy_flag(MEM_WB_cy,cy,clk,MEM_WB_cywrite);

flag_pp z_flag(MEM_WB_z,z,clk,MEM_WB_zwrite);

mod1 lasa(ID_RR_IM_d[15:12],clk,RF_d1_new,comp1,regr1,memloc1);

mod0 lmsm(ID_RR_IM_d[15:12],ID_RR_IM_d[7:0],RF_d1_new,clk,comp,regr,memloc);

controller_pp contr1(regr,ID_RR_IM_d,comp,comp1,cy_new,z_new,alu2_z,pcwrite,regwrite1,regwrite0,read,write,cywrite,zwrite,alu2srca,alu3srcb,DMsrcd,aluop,RFsrca2,RFsrcd3,RFsrcd4,alu2srcb,DMsrca,pcsrc,RFsrca3,branch);

hazard_control_pp h1(RR_EX_z_new,RR_EX_cy_new,EX_MEM_z_new,EX_MEM_cy_new,MEM_WB_z_new,MEM_WB_cy_new,RR_EX_pcsrc,EX_MEM_pcsrc,RR_EX_branch,alu2_z,ID_RR_IM_d,RR_EX_IM_d,EX_MEM_IM_d,MEM_WB_IM_d,RR_EX_comp,EX_MEM_comp,MEM_WB_comp,RR_EX_comp1,EX_MEM_comp1,MEM_WB_comp1,regr,RR_EX_regr,EX_MEM_regr,MEM_WB_regr,regr1,RR_EX_regr1,EX_MEM_regr1,MEM_WB_regr1,RF_d1_select,RF_d2_select,stall_load,cy_select,z_select,stall_jump,stall_jump_ex,lookup[RR_EX_lookupindex][33]);



always @(posedge clk)// IF stage
begin
if(pcwrite & stall_load)
begin
if(stall_jump & stall_jump_ex)
begin
IF_ID_pc<=pc;
IF_ID_IM_d<=IM_d;
pc<=pc_next;
IF_ID_alu1out<=alu1out;
IF_ID_lookupindex1<=lookupindex;
IF_ID_lookupwrite<=lookupwrite;
end
else if(lookup[RR_EX_lookupindex][33] & ~stall_jump & ((RR_EX_IM_d[15:12]==4'b1000)||(RR_EX_IM_d[15:12]==4'b1001))) begin
IF_ID_pc<=pc;
IF_ID_IM_d<=16'h6000;
IF_ID_lookupindex1<=lookupindex;
IF_ID_alu1out<=alu1out;
pc<=lookup[RR_EX_lookupindex][15:0]+16'b1;
IF_ID_lookupwrite<=lookupwrite;
end
else
begin
IF_ID_pc<=pc;
IF_ID_IM_d<=16'h6000;
pc<=pc_next;
IF_ID_alu1out<=alu1out;
IF_ID_lookupindex1<=lookupindex;
IF_ID_lookupwrite<=lookupwrite;
end
end
end

always @(posedge clk)
begin
if(stall_load & pcwrite)
begin
if(stall_jump & stall_jump_ex)
begin
ID_RR_pc<=IF_ID_pc;
ID_RR_IM_d<=IF_ID_IM_d;
ID_RR_alu1out<=IF_ID_alu1out;
ID_RR_lookupindex<=IF_ID_lookupindex;
ID_RR_lookupwrite<=IF_ID_lookupwrite;
end
else
begin
ID_RR_IM_d<=16'h6000;
ID_RR_pc<=IF_ID_pc;
ID_RR_lookupindex<=IF_ID_lookupindex;
ID_RR_alu1out<=IF_ID_alu1out;
ID_RR_lookupwrite<=IF_ID_lookupwrite;
end

end
end


always @(posedge clk)// RR stage
begin
if(stall_load)
begin
if(stall_jump & stall_jump_ex)
begin
RR_EX_RF_d1<=RF_d1_new;
RR_EX_RF_d2<=RF_d2_new;
RR_EX_SE5out<=SE5out;
RR_EX_SE8out<=SE8out;
RR_EX_ALout<=ALout;
RR_EX_pc<=ID_RR_pc;
RR_EX_alu1out<=ID_RR_alu1out;
RR_EX_memloc<=memloc;
RR_EX_memloc1<=memloc1;
RR_EX_IM_d<=ID_RR_IM_d;
RR_EX_regr<=regr;
RR_EX_regr1<=regr1;
RR_EX_comp<=comp;
RR_EX_comp1<=comp1;
RR_EX_lookupwrite<=ID_RR_lookupwrite;
RR_EX_lookupindex<=ID_RR_lookupindex;
RR_EX_z_new<=z_new;
RR_EX_cy_new<=cy_new;

RR_EX_pcsrc<=pcsrc;
RR_EX_RFsrca3<=RFsrca3;
RR_EX_RFsrcd3<=RFsrcd3;
RR_EX_regwrite0<=regwrite0;
RR_EX_regwrite1<=regwrite1;
RR_EX_alu2srca<=alu2srca;
RR_EX_alu2srcb<=alu2srcb;
RR_EX_aluop<=aluop;
RR_EX_DMsrca<=DMsrca;
RR_EX_DMsrcd<=DMsrcd;
RR_EX_read<=read;
RR_EX_write<=write;
RR_EX_alu3srcb<=alu3srcb;
RR_EX_cywrite<=cywrite;
RR_EX_zwrite<=zwrite;
RR_EX_branch<=branch;
end

else
begin
RR_EX_RF_d1<=RF_d1;
RR_EX_RF_d2<=RF_d2;
RR_EX_SE5out<=16'b0;
RR_EX_SE8out<=16'b0;
RR_EX_ALout<=16'b0;
RR_EX_pc<=ID_RR_pc;
RR_EX_alu1out<=16'b0;
RR_EX_memloc<=memloc;
RR_EX_memloc1<=memloc1;
RR_EX_IM_d<=16'h6000;
RR_EX_regr<=regr;
RR_EX_regr1<=regr1;
RR_EX_comp<=comp;
RR_EX_comp1<=comp1;
RR_EX_lookupwrite<=ID_RR_lookupwrite;
RR_EX_lookupindex<=ID_RR_lookupindex;
RR_EX_z_new<=z_new;
RR_EX_cy_new<=cy_new;

RR_EX_pcsrc<=0;
RR_EX_RFsrca3<=0;
RR_EX_RFsrcd3<=0;
RR_EX_regwrite0<=1'b1;
RR_EX_regwrite1<=1'b0;
RR_EX_alu2srca<=0;
RR_EX_alu2srcb<=0;
RR_EX_aluop<=0;
RR_EX_DMsrca<=DMsrca;
RR_EX_DMsrcd<=DMsrcd;
RR_EX_read<=1'b0;
RR_EX_write<=1'b0;
RR_EX_alu3srcb<=0;
RR_EX_cywrite<=1'b0;
RR_EX_zwrite<=1'b0;
RR_EX_branch<=0;

end
end
end

always @(posedge clk)// Ex stage
begin
if(stall_jump_ex)
begin
EX_MEM_alu2out<=alu2out;
EX_MEM_RF_d1<=RR_EX_RF_d1;
EX_MEM_RF_d2<=RR_EX_RF_d2;
EX_MEM_alu1out<=RR_EX_alu1out;
EX_MEM_ALout<=RR_EX_ALout;
EX_MEM_IM_d<=RR_EX_IM_d;
EX_MEM_memloc<=RR_EX_memloc;
EX_MEM_memloc1<=RR_EX_memloc1;
EX_MEM_regr<=RR_EX_regr;
EX_MEM_regr1<=RR_EX_regr1;
EX_MEM_cy<=alu2_cy;
EX_MEM_z<=alu2_z;
EX_MEM_comp<=RR_EX_comp;
EX_MEM_comp1<=RR_EX_comp1;
EX_MEM_z_new<=RR_EX_z_new;
EX_MEM_cy_new<=RR_EX_cy_new;

EX_MEM_pcsrc<=RR_EX_pcsrc;
EX_MEM_RFsrca3<=RR_EX_RFsrca3;
EX_MEM_RFsrcd3<=RR_EX_RFsrcd3;
EX_MEM_regwrite1<=RR_EX_regwrite1;
EX_MEM_DMsrca<=RR_EX_DMsrca;
EX_MEM_DMsrcd<=RR_EX_DMsrcd;
EX_MEM_read<=RR_EX_read;
EX_MEM_write<=RR_EX_write;
EX_MEM_cywrite<=RR_EX_cywrite;
EX_MEM_zwrite<=RR_EX_zwrite;
end

else
begin
EX_MEM_alu2out<=alu2out;
EX_MEM_RF_d1<=RR_EX_RF_d1;
EX_MEM_RF_d2<=RR_EX_RF_d2;
EX_MEM_alu1out<=RR_EX_alu1out;
EX_MEM_ALout<=RR_EX_ALout;
EX_MEM_IM_d<=16'h6000;
EX_MEM_memloc<=RR_EX_memloc;
EX_MEM_memloc1<=RR_EX_memloc1;
EX_MEM_regr<=RR_EX_regr;
EX_MEM_regr1<=RR_EX_regr1;
EX_MEM_cy<=alu2_cy;
EX_MEM_z<=alu2_z;
EX_MEM_comp<=RR_EX_comp;
EX_MEM_comp1<=RR_EX_comp1;
EX_MEM_z_new<=RR_EX_z_new;
EX_MEM_cy_new<=RR_EX_cy_new;

EX_MEM_pcsrc<=0;
EX_MEM_RFsrca3<=0;
EX_MEM_RFsrcd3<=0;
EX_MEM_regwrite1<=0;
EX_MEM_DMsrca<=0;
EX_MEM_DMsrcd<=0;
EX_MEM_read<=0;
EX_MEM_write<=0;
EX_MEM_cywrite<=0;
EX_MEM_zwrite<=0;
end

end

always @(posedge clk)
begin
MEM_WB_alu2out<=EX_MEM_alu2out;
MEM_WB_alu1out<=EX_MEM_alu1out;
MEM_WB_DM_d<=DM_d;
MEM_WB_ALout<=EX_MEM_ALout;
MEM_WB_IM_d<=EX_MEM_IM_d;
MEM_WB_regr<=EX_MEM_regr;
MEM_WB_regr1<=EX_MEM_regr1;
MEM_WB_cy<=EX_MEM_cy;
MEM_WB_z<=EX_MEM_z;
MEM_WB_comp<=EX_MEM_comp;
MEM_WB_comp1<=EX_MEM_comp1;
MEM_WB_z_new<=EX_MEM_z_new;
MEM_WB_cy_new<=EX_MEM_cy_new;

MEM_WB_RFsrca3<=EX_MEM_RFsrca3;
MEM_WB_RFsrcd3<=EX_MEM_RFsrcd3;
MEM_WB_regwrite1<=EX_MEM_regwrite1;
MEM_WB_cywrite<=EX_MEM_cywrite;
MEM_WB_zwrite<=EX_MEM_zwrite;

end

endmodule