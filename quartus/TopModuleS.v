module TopModuleS(CLOCK_50, VGA_VS, VGA_HS, VGA_CLK,COLOR,led1,swa,swb,swc,swd);

input CLOCK_50;
output reg [7:0] led1;
output VGA_HS, VGA_VS; 
output reg VGA_CLK=0;
output wire [7:0]COLOR;
input swa,swb,swc,swd;

reg [7:0] color_i;

wire READY;
wire[9:0] pos_H, pos_V;

reg[7:0] blank[0:2499];

reg[7:0] blue0[0:2499];
reg[7:0] blue1[0:2499];
reg[7:0] blue2[0:2499];
reg[7:0] blue3[0:2499];
/*
reg[7:0] green0[0:2499];
reg[7:0] green1[0:2499];
reg[7:0] green2[0:2499];
reg[7:0] green3[0:2499];

reg[7:0] red0[0:2499];
reg[7:0] red1[0:2499];
reg[7:0] red2[0:2499];
reg[7:0] red3[0:2499];

reg[7:0] purple0[0:2499];
reg[7:0] purple1[0:2499];
reg[7:0] purple2[0:2499];
reg[7:0] purple3[0:2499];

*/
parameter bPosX1 = 200;
parameter bPosX2 = 300;
parameter bPosX3 = 400;
parameter bPosX4 = 500;


parameter bPosY1 = 100;
parameter bPosY2 = 160;
parameter bPosY3 = 220;
parameter bPosY4 = 280;
parameter bPosY5 = 340;
parameter bPosY6 = 400;



parameter s=50;

initial begin
$readmemh("blank.txt", blank);

$readmemh("blue0.txt", blue0);
$readmemh("blue1.txt", blue1);
$readmemh("blue2.txt", blue2);
$readmemh("blue3.txt", blue3);
/*
$readmemh("green0.txt", green0);
$readmemh("green1.txt", green1);
$readmemh("green2.txt", green2);
$readmemh("green3.txt", green3);

$readmemh("red0.txt", red0);
$readmemh("red1.txt", red1);
$readmemh("red2.txt", red2);
$readmemh("red3.txt", red3);

$readmemh("purple0.txt", purple0);
$readmemh("purple1.txt", purple1);
$readmemh("purple2.txt", purple2);
$readmemh("purple3.txt", purple3);
*/
end
always @(posedge CLOCK_50) begin 
	VGA_CLK = ~VGA_CLK;
end

VGA_SyncS SYNC(.vga_CLK(VGA_CLK), .VSync(VGA_VS), .HSync(VGA_HS), .vga_Ready(READY), .pos_H(pos_H), .pos_V(pos_V));



always @(posedge VGA_CLK) begin 	
	
	
	// 1st Buffer
	if(pos_H>=bPosX1 && pos_H<bPosX1+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		   if(swa) color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY1}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY1}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY1}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY1}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY1}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY2}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY2}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY2}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY2}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY2}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY3}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY3}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY3}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY3}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY3}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY4}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY4}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY4}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY4}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY4}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY5}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY5}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY5}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY5}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY5}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY6}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY6}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY6}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY6}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY6}];
			else color_i <= 8'h0;
		end
		else color_i <= 8'h0;
	end
	
	
	// 2nd Buffer
	else if(pos_H>=bPosX2 && pos_H<bPosX2+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		   if(swa) color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
			else color_i <= 8'h0;
		end
		else color_i <= 8'h0;
	end
	
	// 3rd Buffer
	else if(pos_H>=bPosX3 && pos_H<bPosX3+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		   if(swa) color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
			else color_i <= 8'h0;
		end
		else color_i <= 8'h0;
	end
	
	// 4th Buffer
	else if(pos_H>=bPosX4 && pos_H<bPosX4+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		   if(swa) color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
			else color_i <= 8'h0;
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(swa) color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
			else if(swb) color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
			else if(swc) color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
			else if(swd) color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
			else if(!swa && !swb && !swc && !swd) color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
			else color_i <= 8'h0;
		end
		else color_i <= 8'h0;
	end
	

	else begin
			   color_i <= 8'h0;
	end
		

	
end



	assign COLOR = READY ? color_i : 8'h0;

endmodule