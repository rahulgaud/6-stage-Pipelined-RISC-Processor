module hazard_control_pp(RR_EX_z_new,RR_EX_cy_new,EX_MEM_z_new,EX_MEM_cy_new,MEM_WB_z_new,MEM_WB_cy_new,RR_EX_pcsrc,EX_MEM_pcsrc,RR_EX_branch,alu2_z,ID_RR_IM_d,RR_EX_IM_d,EX_MEM_IM_d,MEM_WB_IM_d,RR_EX_comp,EX_MEM_comp,MEM_WB_comp,RR_EX_comp1,EX_MEM_comp1,MEM_WB_comp1,regr,RR_EX_regr,EX_MEM_regr,MEM_WB_regr,regr1,RR_EX_regr1,EX_MEM_regr1,MEM_WB_regr1,RF_d1_select,RF_d2_select,stall_load,cy_select,z_select,stall_jump,stall_jump_ex,HB);
input [15:0] ID_RR_IM_d,RR_EX_IM_d,EX_MEM_IM_d,MEM_WB_IM_d;
input RR_EX_z_new,RR_EX_cy_new,EX_MEM_z_new,EX_MEM_cy_new,MEM_WB_z_new,MEM_WB_cy_new;
input RR_EX_comp,EX_MEM_comp,MEM_WB_comp,RR_EX_comp1,EX_MEM_comp1,MEM_WB_comp1;
input [2:0] regr,RR_EX_regr,EX_MEM_regr,MEM_WB_regr,regr1,RR_EX_regr1,EX_MEM_regr1,MEM_WB_regr1;
input [2:0] RR_EX_pcsrc,EX_MEM_pcsrc;
input RR_EX_branch,alu2_z;
input HB;
output reg [3:0] RF_d1_select=4'b0000,RF_d2_select=4'b0000;
output reg stall_load=1'b1,stall_jump=1'b1,stall_jump_ex=1'b1;
output reg [1:0] cy_select,z_select;

always @(*)// stall_load
begin
if((RR_EX_IM_d[15:12]==4'b0100)&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111))&&((RR_EX_IM_d[11:9]==ID_RR_IM_d[11:9]))&&(RR_EX_IM_d!=EX_MEM_IM_d))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==RR_EX_IM_d[11:9]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==RR_EX_IM_d[11:9]))))
stall_load=1'b0;
else if((RR_EX_IM_d[15:12]==4'b1100)&&((RR_EX_IM_d[3'b111-ID_RR_IM_d[11:9]]==1'b1)||((ID_RR_IM_d[15:12]==4'b1101)&&(RR_EX_IM_d[3'b111-regr]==1'b1))||((ID_RR_IM_d[15:12]==4'b1111)&&(RR_EX_IM_d[3'b111-regr1]==1'b1)))&&((RR_EX_IM_d[7:0]==8'd1)||(RR_EX_IM_d[7:0]==8'd2)||(RR_EX_IM_d[7:0]==8'd4)||(RR_EX_IM_d[7:0]==8'd8)||(RR_EX_IM_d[7:0]==8'd16)||(RR_EX_IM_d[7:0]==8'd32)||(RR_EX_IM_d[7:0]==8'd64)||(RR_EX_IM_d[7:0]==8'd128))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111))&&(RR_EX_IM_d!=EX_MEM_IM_d))
stall_load=1'b0;
else if((RR_EX_IM_d[15:12]==4'b0100)&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(RR_EX_IM_d[11:9]==ID_RR_IM_d[8:6])&&(RR_EX_IM_d!=EX_MEM_IM_d))
stall_load=1'b0;
else if((RR_EX_IM_d[15:12]==4'b1100)&&(RR_EX_IM_d[3'b111-ID_RR_IM_d[8:6]]==1'b1)&&((RR_EX_IM_d[7:0]==8'd1)||(RR_EX_IM_d[7:0]==8'd2)||(RR_EX_IM_d[7:0]==8'd4)||(RR_EX_IM_d[7:0]==8'd8)||(RR_EX_IM_d[7:0]==8'd16)||(RR_EX_IM_d[7:0]==8'd32)||(RR_EX_IM_d[7:0]==8'd64)||(RR_EX_IM_d[7:0]==8'd128))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(RR_EX_IM_d!=EX_MEM_IM_d))
stall_load=1'b0;
else if((RR_EX_IM_d[15:12]==4'b1100)&&(RR_EX_comp==1'b1)&&((RR_EX_regr==ID_RR_IM_d[11:9])||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==RR_EX_regr))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==RR_EX_regr)))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111))&&(RR_EX_regr!=EX_MEM_regr))
stall_load=1'b0;
else if((RR_EX_IM_d[15:12]==4'b1100)&&(RR_EX_comp==1'b1)&&(RR_EX_regr==ID_RR_IM_d[8:6])&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(RR_EX_regr!=EX_MEM_regr))
stall_load=1'b0;
else if((RR_EX_IM_d[15:12]==4'b1110)&&(RR_EX_comp1==1'b1)&&((RR_EX_regr1==ID_RR_IM_d[11:9])||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==RR_EX_regr1))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==RR_EX_regr1)))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111))&&(RR_EX_regr1!=EX_MEM_regr1))
stall_load=1'b0;
else if((RR_EX_IM_d[15:12]==4'b1110)&&(RR_EX_comp1==1'b1)&&(RR_EX_regr1==ID_RR_IM_d[8:6])&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(RR_EX_regr1!=EX_MEM_regr1))
stall_load=1'b0;
else
stall_load=1'b1;
end

always @(*)
begin
//if((RR_EX_pcsrc==3'b001)||(RR_EX_pcsrc==3'b010)||((RR_EX_pcsrc==3'b100)&&((~RR_EX_branch)||(alu2_z)))||(RR_EX_pcsrc==3'b101))
//stall_jump=1'b0;
//else
//stall_jump=1'b1;

if((RR_EX_pcsrc==3'b001)||(RR_EX_pcsrc==3'b010)||(RR_EX_pcsrc==3'b101))
stall_jump=1'b0;
else if(((RR_EX_pcsrc==3'b100)&&((~RR_EX_branch)||(alu2_z))&&(HB==1'b0))||((RR_EX_pcsrc!=3'b100)&&(HB==1'b1)&&((RR_EX_IM_d[15:12]==4'b1000)||(RR_EX_IM_d[15:12]==4'b1001))))
stall_jump=1'b0;
else
stall_jump=1'b1;

if(EX_MEM_pcsrc==3'b011)
stall_jump_ex=1'b0;
else 
stall_jump_ex=1'b1;
end


always @(*)// RF_d1
begin
if((((RR_EX_IM_d[15:12]==4'b0001)&&((RR_EX_IM_d[1:0]==2'b00)||(RR_EX_IM_d[1:0]==2'b11)||((RR_EX_IM_d[1:0]==2'b10)&&(RR_EX_cy_new==1'b1))||((RR_EX_IM_d[1:0]==2'b01)&&(RR_EX_z_new==1'b1))))||((RR_EX_IM_d[15:12]==4'b0010)&&((RR_EX_IM_d[1:0]==2'b00)||((RR_EX_IM_d[1:0]==2'b10)&&(RR_EX_cy_new==1'b1))||((RR_EX_IM_d[1:0]==2'b01)&&(RR_EX_z_new==1'b1)))))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(RR_EX_IM_d[5:3]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b0001;//alu2out first instr ADD,ADC,ADZ,ADL,NDU,NDC,NDZ
else if((RR_EX_IM_d[15:12]==4'b0000)&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(RR_EX_IM_d[8:6]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b0001;//alu2out ADI
else if(((RR_EX_IM_d[15:12]==4'b1001)||(RR_EX_IM_d[15:12]==4'b1010))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(RR_EX_IM_d[11:9]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b1001;//RR_EX_alu1out JAL JLR
else if((RR_EX_IM_d[15:12]==4'b0011)&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(RR_EX_IM_d[11:9]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b0100;//RR_EX_ALout LHI
else if((((EX_MEM_IM_d[15:12]==4'b0001)&&((EX_MEM_IM_d[1:0]==2'b00)||(EX_MEM_IM_d[1:0]==2'b11)||((EX_MEM_IM_d[1:0]==2'b10)&&(EX_MEM_cy_new==1'b1))||((EX_MEM_IM_d[1:0]==2'b01)&&(EX_MEM_z_new==1'b1))))||((EX_MEM_IM_d[15:12]==4'b0010)&&((EX_MEM_IM_d[1:0]==2'b00)||((EX_MEM_IM_d[1:0]==2'b10)&&(EX_MEM_cy_new==1'b1))||((EX_MEM_IM_d[1:0]==2'b01)&&(EX_MEM_z_new==1'b1)))))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(EX_MEM_IM_d[5:3]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b0010;//EX_MEM_alu2out ADD
else if((EX_MEM_IM_d[15:12]==4'b0000)&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(EX_MEM_IM_d[8:6]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b0010;//EX_MEM_alu2out ADI
else if((EX_MEM_IM_d[15:12]==4'b0011)&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(EX_MEM_IM_d[11:9]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b0101;//EX_MEM_ALout LHI
else if((EX_MEM_IM_d[15:12]==4'b0100)&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(EX_MEM_IM_d[11:9]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b0111;//DM_d LW
else if(((EX_MEM_IM_d[15:12]==4'b1001)||(EX_MEM_IM_d[15:12]==4'b1010))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(EX_MEM_IM_d[11:9]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b1010;//EX_MEM_alu1out JAl JLR
else if((EX_MEM_IM_d[15:12]==4'b1100)&&(EX_MEM_IM_d[3'b111-ID_RR_IM_d[11:9]]==1'b1)&&((EX_MEM_IM_d[7:0]==8'd1)||(EX_MEM_IM_d[7:0]==8'd2)||(EX_MEM_IM_d[7:0]==8'd4)||(EX_MEM_IM_d[7:0]==8'd8)||(EX_MEM_IM_d[7:0]==8'd16)||(EX_MEM_IM_d[7:0]==8'd32)||(EX_MEM_IM_d[7:0]==8'd64)||(EX_MEM_IM_d[7:0]==8'd128))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011)))
RF_d1_select=4'b0111;//DM_d LM
else if((EX_MEM_IM_d[15:12]==4'b1100)&&(RR_EX_comp==1'b1)&&(EX_MEM_regr==ID_RR_IM_d[11:9])&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011)))
RF_d1_select=4'b0111;//DM_d LM
else if((EX_MEM_IM_d[15:12]==4'b1110)&&(RR_EX_comp1==1'b1)&&(EX_MEM_regr1==ID_RR_IM_d[11:9])&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011)))
RF_d1_select=4'b0111;//DM_d LA
else if((((MEM_WB_IM_d[15:12]==4'b0001)&&((MEM_WB_IM_d[1:0]==2'b00)||(MEM_WB_IM_d[1:0]==2'b11)||((MEM_WB_IM_d[1:0]==2'b10)&&(MEM_WB_cy_new==1'b1))||((MEM_WB_IM_d[1:0]==2'b01)&&(MEM_WB_z_new==1'b1))))||((MEM_WB_IM_d[15:12]==4'b0010)&&((MEM_WB_IM_d[1:0]==2'b00)||((MEM_WB_IM_d[1:0]==2'b10)&&(MEM_WB_cy_new==1'b1))||((MEM_WB_IM_d[1:0]==2'b01)&&(MEM_WB_z_new==1'b1)))))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(MEM_WB_IM_d[5:3]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b0011;//MEM_WB_alu2out ADD
else if((MEM_WB_IM_d[15:12]==4'b0000)&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(MEM_WB_IM_d[8:6]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b0011;//MEM_WB_alu2out ADI
else if((MEM_WB_IM_d[15:12]==4'b0011)&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(MEM_WB_IM_d[11:9]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b0110;//MEM_WB_ALout LHI
else if((MEM_WB_IM_d[15:12]==4'b0100)&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(MEM_WB_IM_d[11:9]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b1000;//MEM_WB_DM_d LW
else if(((MEM_WB_IM_d[15:12]==4'b1001)||(MEM_WB_IM_d[15:12]==4'b1010))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011))&&(MEM_WB_IM_d[11:9]==ID_RR_IM_d[11:9]))
RF_d1_select=4'b1011;//MEM_WB_alu1out JAL JLR
else if((MEM_WB_IM_d[15:12]==4'b1100)&&(RR_EX_comp==1'b1)&&(MEM_WB_regr==ID_RR_IM_d[11:9])&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011)))
RF_d1_select=4'b1000;//MEM_WB_DM_d LM
else if((MEM_WB_IM_d[15:12]==4'b1110)&&(RR_EX_comp1==1'b1)&&(MEM_WB_regr1==ID_RR_IM_d[11:9])&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0000)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1100)||(ID_RR_IM_d[15:12]==4'b1101)||(ID_RR_IM_d[15:12]==4'b1110)||(ID_RR_IM_d[15:12]==4'b1111)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1011)))
RF_d1_select=4'b1000;//MEM_WB_DM_d LM
else
RF_d1_select=4'b0000;
end

always @(*) // RF_d2
begin
if((((RR_EX_IM_d[15:12]==4'b0001)&&((RR_EX_IM_d[1:0]==2'b00)||(RR_EX_IM_d[1:0]==2'b11)||((RR_EX_IM_d[1:0]==2'b10)&&(RR_EX_cy_new==1'b1))||((RR_EX_IM_d[1:0]==2'b01)&&(RR_EX_z_new==1'b1))))||((RR_EX_IM_d[15:12]==4'b0010)&&((RR_EX_IM_d[1:0]==2'b00)||((RR_EX_IM_d[1:0]==2'b10)&&(RR_EX_cy_new==1'b1))||((RR_EX_IM_d[1:0]==2'b01)&&(RR_EX_z_new==1'b1)))))&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(RR_EX_IM_d[5:3]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==RR_EX_IM_d[5:3]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==RR_EX_IM_d[5:3]))))
RF_d2_select=4'b0001;//alu2out first instr ADD,ADC,ADZ,ADL,NDU,NDC,NDZ
else if((RR_EX_IM_d[15:12]==4'b0000)&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(RR_EX_IM_d[8:6]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==RR_EX_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==RR_EX_IM_d[8:6]))))
RF_d2_select=4'b0001;//alu2out ADI
else if(((RR_EX_IM_d[15:12]==4'b1001)||(RR_EX_IM_d[15:12]==4'b1010))&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(RR_EX_IM_d[11:9]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==RR_EX_IM_d[11:9]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==RR_EX_IM_d[11:9]))))
RF_d2_select=4'b1001;//RR_EX_alu1out JAL JLR
else if((RR_EX_IM_d[15:12]==4'b0011)&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(RR_EX_IM_d[11:9]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==RR_EX_IM_d[11:9]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==RR_EX_IM_d[11:9]))))
RF_d2_select=4'b0100;//RR_EX_ALout LHI
else if((((EX_MEM_IM_d[15:12]==4'b0001)&&((EX_MEM_IM_d[1:0]==2'b00)||(EX_MEM_IM_d[1:0]==2'b11)||((EX_MEM_IM_d[1:0]==2'b10)&&(EX_MEM_cy_new==1'b1))||((EX_MEM_IM_d[1:0]==2'b01)&&(EX_MEM_z_new==1'b1))))||((EX_MEM_IM_d[15:12]==4'b0010)&&((EX_MEM_IM_d[1:0]==2'b00)||((EX_MEM_IM_d[1:0]==2'b10)&&(EX_MEM_cy_new==1'b1))||((EX_MEM_IM_d[1:0]==2'b01)&&(EX_MEM_z_new==1'b1)))))&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(EX_MEM_IM_d[5:3]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==EX_MEM_IM_d[5:3]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==EX_MEM_IM_d[5:3]))))
RF_d2_select=4'b0010;//EX_MEM_alu2out ADD
else if((EX_MEM_IM_d[15:12]==4'b0000)&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(EX_MEM_IM_d[8:6]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==EX_MEM_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==EX_MEM_IM_d[8:6]))))
RF_d2_select=4'b0010;//EX_MEM_alu2out ADI
else if((EX_MEM_IM_d[15:12]==4'b0011)&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(EX_MEM_IM_d[11:9]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==EX_MEM_IM_d[11:9]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==EX_MEM_IM_d[11:9]))))
RF_d2_select=4'b0101;//EX_MEM_ALout LHI
else if((EX_MEM_IM_d[15:12]==4'b0100)&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(EX_MEM_IM_d[11:9]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==EX_MEM_IM_d[11:9]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==EX_MEM_IM_d[11:9]))))
RF_d2_select=4'b0111;//DM_d LW
else if(((EX_MEM_IM_d[15:12]==4'b1001)||(EX_MEM_IM_d[15:12]==4'b1010))&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(EX_MEM_IM_d[11:9]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==EX_MEM_IM_d[11:9]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==EX_MEM_IM_d[11:9]))))
RF_d2_select=4'b1010;//EX_MEM_alu1out JAl JLR
else if((EX_MEM_IM_d[15:12]==4'b1100)&&((EX_MEM_IM_d[3'b111-ID_RR_IM_d[8:6]]==1'b1)||((ID_RR_IM_d[15:12]==4'b1101)&&(EX_MEM_IM_d[3'b111-regr]==1'b1))||((ID_RR_IM_d[15:12]==4'b1111)&&(EX_MEM_IM_d[3'b111-regr1]==1'b1)))&&((EX_MEM_IM_d[7:0]==8'd1)||(EX_MEM_IM_d[7:0]==8'd2)||(EX_MEM_IM_d[7:0]==8'd4)||(EX_MEM_IM_d[7:0]==8'd8)||(EX_MEM_IM_d[7:0]==8'd16)||(EX_MEM_IM_d[7:0]==8'd32)||(EX_MEM_IM_d[7:0]==8'd64)||(EX_MEM_IM_d[7:0]==8'd128))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010)))
RF_d2_select=4'b0111;//DM_d LM
else if((EX_MEM_IM_d[15:12]==4'b1100)&&(RR_EX_comp==1'b1)&&((EX_MEM_regr==ID_RR_IM_d[8:6])||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==EX_MEM_regr))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==EX_MEM_regr)))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010)))
RF_d2_select=4'b0111;//DM_d LM
else if((EX_MEM_IM_d[15:12]==4'b1110)&&(RR_EX_comp1==1'b1)&&((EX_MEM_regr1==ID_RR_IM_d[8:6])||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==EX_MEM_regr1))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==EX_MEM_regr1)))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010)))
RF_d2_select=4'b0111;//DM_d LA
else if((((MEM_WB_IM_d[15:12]==4'b0001)&&((MEM_WB_IM_d[1:0]==2'b00)||(MEM_WB_IM_d[1:0]==2'b11)||((MEM_WB_IM_d[1:0]==2'b10)&&(MEM_WB_cy_new==1'b1))||((MEM_WB_IM_d[1:0]==2'b01)&&(MEM_WB_z_new==1'b1))))||((MEM_WB_IM_d[15:12]==4'b0010)&&((MEM_WB_IM_d[1:0]==2'b00)||((MEM_WB_IM_d[1:0]==2'b10)&&(MEM_WB_cy_new==1'b1))||((MEM_WB_IM_d[1:0]==2'b01)&&(MEM_WB_z_new==1'b1)))))&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(MEM_WB_IM_d[5:3]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==MEM_WB_IM_d[5:3]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==MEM_WB_IM_d[5:3]))))
RF_d2_select=4'b0011;//MEM_WB_alu2out ADD
else if((MEM_WB_IM_d[15:12]==4'b0000)&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(MEM_WB_IM_d[8:6]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==MEM_WB_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==MEM_WB_IM_d[8:6]))))
RF_d2_select=4'b0011;//MEM_WB_alu2out ADI
else if((MEM_WB_IM_d[15:12]==4'b0011)&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(MEM_WB_IM_d[11:9]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==MEM_WB_IM_d[11:9]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==MEM_WB_IM_d[11:9]))))
RF_d2_select=4'b0110;//MEM_WB_ALout LHI
else if((MEM_WB_IM_d[15:12]==4'b0100)&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(MEM_WB_IM_d[11:9]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==MEM_WB_IM_d[11:9]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==MEM_WB_IM_d[11:9]))))
RF_d2_select=4'b1000;//MEM_WB_DM_d LW
else if(((MEM_WB_IM_d[15:12]==4'b1001)||(MEM_WB_IM_d[15:12]==4'b1010))&&((((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010))&&(MEM_WB_IM_d[11:9]==ID_RR_IM_d[8:6]))||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==MEM_WB_IM_d[11:9]))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==MEM_WB_IM_d[11:9]))))
RF_d2_select=4'b1011;//MEM_WB_alu1out JAL JLR
else if((MEM_WB_IM_d[15:12]==4'b1100)&&(RR_EX_comp==1'b1)&&((MEM_WB_regr==ID_RR_IM_d[8:6])||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==MEM_WB_regr))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==MEM_WB_regr)))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010)))
RF_d2_select=4'b1000;//MEM_WB_DM_d LM
else if((MEM_WB_IM_d[15:12]==4'b1110)&&(RR_EX_comp1==1'b1)&&((MEM_WB_regr1==ID_RR_IM_d[8:6])||((ID_RR_IM_d[15:12]==4'b1101)&&(regr==MEM_WB_regr1))||((ID_RR_IM_d[15:12]==4'b1111)&&(regr1==MEM_WB_regr1)))&&((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010)||(ID_RR_IM_d[15:12]==4'b0100)||(ID_RR_IM_d[15:12]==4'b0101)||(ID_RR_IM_d[15:12]==4'b1000)||(ID_RR_IM_d[15:12]==4'b1010)))
RF_d2_select=4'b1000;//MEM_WB_DM_d LM
else
RF_d2_select=4'b0000;
end

always @(*)
begin
if(((RR_EX_IM_d[15:12]==4'b0001)||(RR_EX_IM_d[15:12]==4'b0000)||(RR_EX_IM_d[15:12]==4'b0010)||(RR_EX_IM_d[15:12]==4'b0100))&&(((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010))&&(ID_RR_IM_d[1:0]==2'b01)))
z_select=2'b01;// alu_z
else if(((EX_MEM_IM_d[15:12]==4'b0001)||(EX_MEM_IM_d[15:12]==4'b0000)||(EX_MEM_IM_d[15:12]==4'b0010)||(EX_MEM_IM_d[15:12]==4'b0100))&&(((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010))&&(ID_RR_IM_d[1:0]==2'b01)))
z_select=2'b10;// EX-MEM_z
else if(((MEM_WB_IM_d[15:12]==4'b0001)||(MEM_WB_IM_d[15:12]==4'b0000)||(MEM_WB_IM_d[15:12]==4'b0010)||(MEM_WB_IM_d[15:12]==4'b0100))&&(((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010))&&(ID_RR_IM_d[1:0]==2'b01)))
z_select=2'b11;// MEM_WB_z
else
z_select=2'b00; // z
end

always @(*)
begin
if(((RR_EX_IM_d[15:12]==4'b0001)||(RR_EX_IM_d[15:12]==4'b0000))&&(((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010))&&(ID_RR_IM_d[1:0]==2'b10)))
cy_select=2'b01;// alu_cy
else if(((EX_MEM_IM_d[15:12]==4'b0001)||(EX_MEM_IM_d[15:12]==4'b0000))&&(((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010))&&(ID_RR_IM_d[1:0]==2'b10)))
cy_select=2'b10;// EX_MEM_cy
else if(((MEM_WB_IM_d[15:12]==4'b0001)||(MEM_WB_IM_d[15:12]==4'b0000))&&(((ID_RR_IM_d[15:12]==4'b0001)||(ID_RR_IM_d[15:12]==4'b0010))&&(ID_RR_IM_d[1:0]==2'b10)))
cy_select=2'b11;// MEM_WB_cy
else
cy_select=2'b00;
end
















endmodule
