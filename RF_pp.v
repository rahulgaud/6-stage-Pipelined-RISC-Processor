module RF_pp(a1,a2,a3,d1,d2,d3,d4,clk,regwrite1,regwrite0);
input clk,regwrite1,regwrite0;
input [2:0] a1,a2,a3;
input [15:0] d3,d4;
output [15:0] d1,d2;

reg [15:0] RF [7:0]; 

assign d1=RF[a1];
assign d2=RF[a2];

always @(posedge clk)
begin
if(regwrite1==1'b1)
RF[a3]<=d3;
if(regwrite0==1'b1)
RF[7]<=d4;

end

endmodule

