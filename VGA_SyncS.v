module VGA_SyncS(vga_CLK, VSync, HSync, vga_Ready, pos_H, pos_V);

input vga_CLK;
output reg [9:0] pos_H, pos_V;
output wire vga_Ready, HSync, VSync;

parameter H_sync = 96;
parameter H_back = 48;
parameter H_front = 16;
parameter one_line = 799;
parameter V_sync = 2;
parameter V_back = 32;
parameter V_front = 11;
parameter one_frame = 524; 

wire vga_ReadyH, vga_ReadyV;

initial begin
	pos_H = 10'd0;
	pos_V = 10'd0;
end

always @(posedge vga_CLK) begin
	if(pos_H == one_line) begin 
		pos_H <= 0;
		if(pos_V == one_frame) pos_V <= 0;
		else pos_V <= pos_V + 1;
		end
	else pos_H <= pos_H + 1;
end

assign HSync = (pos_H < H_sync);
assign VSync = (pos_V < V_sync);
assign vga_ReadyH = (pos_H >= (H_sync+H_back) && pos_H <= (one_line-H_front));
assign vga_ReadyV = (pos_V >= (V_sync+V_back) && pos_V <= (one_frame-V_front));
assign vga_Ready = (vga_ReadyH && vga_ReadyV);

endmodule