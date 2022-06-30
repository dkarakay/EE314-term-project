module TopModuleS(CLOCK_50, VGA_VS, VGA_HS, VGA_CLK, VGA_R, VGA_G, VGA_B,led1);

input CLOCK_50;
output reg [7:0] led1;
output VGA_HS, VGA_VS; 
output reg VGA_CLK=0;
output wire [7:0] VGA_R, VGA_G, VGA_B;

reg [7:0] red, green, blue;
wire READY;
wire[9:0] pos_H, pos_V;

reg[7:0] pieb[0:1599];
reg[7:0] pieg[0:1599];
reg[7:0] pier[0:1599];

reg [10:0]X = 10'd40;
reg [10:0]Y = 10'd40;
reg [10:0]x_limit = 10'd0;
reg [10:0]y_limit = 10'd0;
integer count = 0;


initial begin
$readmemh("pieb.txt", pieb);
$readmemh("pieg.txt", pieg);	
$readmemh("pier.txt", pier);	
x_limit<=0;
y_limit<=0;
count<=0;
//$readmemh("messi_blue.txt", messi_blue);	
//$readmemh("messi_green.txt", messi_green);	
end
always @(posedge CLOCK_50) begin 
	VGA_CLK = ~VGA_CLK;
end

VGA_SyncS SYNC(.vga_CLK(VGA_CLK), .VSync(VGA_VS), .HSync(VGA_HS), .vga_Ready(READY), .pos_H(pos_H), .pos_V(pos_V));



always @(posedge CLOCK_50) begin 	
	if (x_limit > 40)begin
		x_limit <= 0;
		y_limit <= y_limit+1;
	end
	
	if (y_limit > 40)begin
		y_limit <= 0;
		x_limit <= 0;
	end
	
	
	if(pos_H == 455 && pos_V == 195)begin
		red <= 8'hff;		
		green <= 8'h00;
		blue <= 8'h00;

	end
	
	if(pos_H == 456 && pos_V == 195)begin
		red <= 8'hff;
		blue <= 8'h00;
		green <= 8'h00;
	end
	
	if(pos_H == 457 && pos_V == 195)begin
		blue <= 8'hff;
		red <= 8'h00;
		green <= 8'h00;

	end
	
	if(pos_H == 458 && pos_V == 195)begin
		blue <= 8'hff;		
		red <= 8'h00;
		green <= 8'h00;

	end
	
	if(pos_H == 455 && pos_V == 196)begin
		green <= 8'hff;
		red <= 8'h00;
		blue <= 8'h00;
	end
	if(pos_H == 456 && pos_V == 196)begin
		green <= 8'hff;
		red <= 8'h00;
		blue <= 8'h00;
	end
	
	if(pos_H == 457 && pos_V == 196)begin
		red <= 8'hff;
		green <= 8'hff;
		blue <= 8'h00;
	end
	
	if(pos_H == 458 && pos_V == 196)begin
		red <= 8'hff;
		blue <= 8'hff;
		green <= 8'h00;
	end
	
	if (pos_V >200 && pos_H > 300 && pos_H < 450)begin
	if(pos_V == 200+y_limit && y_limit <= 40)begin
		if (pos_H == 300+x_limit && x_limit<=40)begin
				red <= pier[count];
				green <= pieg[count];
				blue <= pieb[count];
				x_limit <= x_limit+1;
				count <= count+1;
				end
	end
	else begin
			red <= 8'h0;
			green <= 8'h0;
			blue <= 8'h0;
			end
	end
	
	if (pos_V <= 150)begin
		if (pos_H <= 250)begin
			red <= pier[1];
			green <= 8'h0;
			blue <= pieb[1];
			end
	end
	
	if (pos_H > 500 && pos_H <= 550)begin
		red <= pier[501];
		green <= pieg[501];
		blue <= pieb[501];
	end
	
	if (pos_H > 550 && pos_H <= 600)begin
		red <= pier[1100];
		green <= pieg[1100];
		blue <= pieb[1100];
	end
	
	if (pos_H > 600)begin
		red <= pier[1400];
		green <= pieg[1400];
		blue <= pieb[1400];
	end
	
	
	
	
	/*if(pos_H < 700)begin
			red <= pieb[count_data];
			green <= messi_green[count_data];
			blue <= messi_blue[count_data];

	end
	count_data <= count_data+1;
	
	
	/*if(pos_H > 700)begin
			red <= 8'hFF;
			green <= 8'hFF;
			blue <= 8'h0;
	end
	
	
	/*
	if(pos_H > 300 && pos_H < 400)begin
			red <= 8'hFF;
			green <= 8'h0;
			blue <= 8'h0;

	end
	
	if(pos_H > 450 && pos_H < 550)begin
			red <= 8'h0;
			green <= 8'hFF;
			blue <= 8'h0;

	end
	
	if(pos_H > 550 && pos_H < 600)begin
			red <= 8'h0;
			green <= 8'h0;
			blue <= 8'hFF;

	end
	
	if(pos_H > 650 && pos_H < 7007)begin
			red <= 8'h0;
			green <= 8'hFF;
			blue <= 8'hFF;

	end
	
	if(pos_H > 750 && pos_H < 800)begin
			red <= 8'hFF;
			green <= 8'hFF;
			blue <= 8'hFF;

	end
	*/
	
end


	/*assign led1 = 1;
	assign VGA_R = red;
	assign VGA_G = green;
	assign VGA_B = blue;
	
	*/
	assign VGA_R = READY ? red : 8'h0;  
	assign VGA_G = READY ? green : 8'h0;
	assign VGA_B = READY ? blue : 8'h0;
	

endmodule