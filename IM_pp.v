module IM_pp(addr,data);
input [15:0] addr;
output [15:0] data;
integer i;
reg [15:0] IM [65535:0];


assign data=IM[addr];

endmodule

