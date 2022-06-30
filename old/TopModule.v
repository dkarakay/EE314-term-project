module TopModule(CLOCK_50, VGA_VS, VGA_HS, VGA_CLK, VGA_R, VGA_G, VGA_B,led1,led2);

input CLOCK_50;
output reg led1,led2;
output VGA_HS, VGA_VS; 
output reg VGA_CLK;
output reg[7:0] VGA_R, VGA_G, VGA_B;

wire READY;
wire[9:0] POS_H, POS_V;

always @(posedge CLOCK_50) begin 
	VGA_CLK = ~VGA_CLK;
end

VGA_Sync SYNC(.vga_CLK(VGA_CLK), .vga_VS(VGA_VS), .vga_HS(VGA_HS), .vga_Ready(READY), .pos_H(POS_H), .pos_V(POS_V));


always @(posedge VGA_CLK) begin
	led1 <= 1;
	led2 <= 0;
	VGA_R <= 8'hFF;  
	VGA_G <= 8'h00;
	VGA_B <= 8'hFF;
	
/*	 if (hcount < 80 && vcount < 480)
    begin
	 
      green <= 8'hFF;
		blue <= 8'hFF;
		red <= 8'h00;
    end
			*/
end
endmodule