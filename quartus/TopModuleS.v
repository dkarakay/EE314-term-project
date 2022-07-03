module TopModuleS(
CLOCK_50, VGA_VS, VGA_HS, VGA_CLK,COLOR,led1,
buffer1,buffer2,buffer3,buffer4,inputReg,btnStart,btn0,btn1

);

input CLOCK_50;
output reg [7:0] led1;
output VGA_HS, VGA_VS; 
output reg VGA_CLK=0;
output wire [7:0]COLOR;

reg [7:0] color_i;

wire READY;
wire[9:0] pos_H, pos_V;

reg[7:0] blank[0:899];

reg[7:0] blue0[0:899];
reg[7:0] blue1[0:899];
reg[7:0] blue2[0:899];
reg[7:0] blue3[0:899];

reg[7:0] green0[0:899];
reg[7:0] green1[0:899];
reg[7:0] green2[0:899];
reg[7:0] green3[0:899];

reg[7:0] red0[0:899];
reg[7:0] red1[0:899];
reg[7:0] red2[0:899];
reg[7:0] red3[0:899];
/*
reg[7:0] purple0[0:899];
reg[7:0] purple1[0:899];
reg[7:0] purple2[0:899];
reg[7:0] purple3[0:899];
*/

parameter bPosX1 = 200;
parameter bPosX2 = 260;
parameter bPosX3 = 320;
parameter bPosX4 = 380;


parameter bPosY1 = 150;
parameter bPosY2 = 190;
parameter bPosY3 = 230;
parameter bPosY4 = 270;
parameter bPosY5 = 310;
parameter bPosY6 = 350;

parameter s=30;


integer indexb1, indexb2, indexb3,indexb4;
output reg [4:0] inputReg;
output reg [18:0] buffer1, buffer2, buffer3, buffer4;
input btnStart;
input btn0;
input btn1;
reg [3:0] dummy;
reg pressed;
integer isStartPressed;
integer checkFourValue;

integer data_read;


initial begin
inputReg <=0;
dummy <= 0;
pressed = 0;
isStartPressed = 0;
checkFourValue = 0;
indexb1 =0;
indexb2 =0;
indexb3 =0;
indexb4 =0;
data_read=0;

buffer1 <=0;
buffer2 <=0;
buffer3 <=0;
buffer4 <=0;


$readmemh("blank.txt", blank);

$readmemh("blue0.txt", blue0);
$readmemh("blue1.txt", blue1);
$readmemh("blue2.txt", blue2);
$readmemh("blue3.txt", blue3);

$readmemh("green0.txt", green0);
$readmemh("green1.txt", green1);
$readmemh("green2.txt", green2);
$readmemh("green3.txt", green3);

$readmemh("red0.txt", red0);
$readmemh("red1.txt", red1);
$readmemh("red2.txt", red2);
$readmemh("red3.txt", red3);
/*
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



always @ (posedge CLOCK_50) begin

	if (btnStart == 0 && isStartPressed <2) begin
		inputReg <=0;
		isStartPressed <= isStartPressed+1;
	end
	
	else if (isStartPressed == 2) begin

		case ({btn0,btn1,pressed}) 
		
		3'b111 : begin
		pressed <= 0 ;
		end
		
		// btn 1
		3'b010 : begin
			dummy[checkFourValue] = 0;
			pressed <= 1 ;
			checkFourValue <= checkFourValue +1;
			if(checkFourValue == 3) begin
				inputReg[4] = 1;
				inputReg[3] = dummy[0];
				inputReg[2] = dummy[1];
				inputReg[1] = dummy[2];
				inputReg[0] = dummy[3];
				isStartPressed <= 0 ;
				checkFourValue <= 0;
				end
		end
		
		// btn 0
		3'b100 :  begin
			dummy[checkFourValue] = 1;
			pressed <= 1 ;
			checkFourValue <= checkFourValue +1;
			if(checkFourValue == 3) begin
				inputReg[4] = 1;
				inputReg[3] = dummy[0];
				inputReg[2] = dummy[1];
				inputReg[1] = dummy[2];
				inputReg[0] = dummy[3];	
				isStartPressed <= 0;
				checkFourValue <= 0;
			end
		end
		endcase		
	
	if (inputReg[4] == 1)begin
		case(inputReg[3:2])
			// 1st Buffer
			2'b00:begin
				buffer1[17:3]=buffer1[14:0];
				buffer1[2:0] = {inputReg[1:0],1'b1};
				indexb1 = indexb1 +3;
			end
			
			// 2nd Buffer
			2'b01:begin
				buffer2[17:3]=buffer2[14:0];
				buffer2[2:0] = {inputReg[1:0],1'b1};
				indexb2 = indexb2 +3;
			end
			
			// 3rd Buffer
			2'b10:begin
				buffer3[17:3]=buffer3[14:0];
				buffer3[2:0] = {inputReg[1:0],1'b1};
				indexb3 = indexb3 +3;
			end
			
			// 4th Buffer
			2'b11:begin
				buffer4[17:3]=buffer4[14:0];
				buffer4[2:0] = {inputReg[1:0],1'b1};
				indexb4 = indexb4 +3;
			end
		endcase
		end
	end
	
end	




always @(posedge VGA_CLK) begin 	
	
	
	// 1st Buffer
	if(pos_H>=bPosX1 && pos_H<bPosX1+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		   if(buffer1[15])begin
				case(buffer1[17:16])
				2'b00: color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY1}];
				2'b01: color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY1}];
				2'b10: color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY1}];
				2'b11: color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY1}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY1}];
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(buffer1[12])begin
				case(buffer1[14:13])
				2'b00: color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY2}];
				2'b01: color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY2}];
				2'b10: color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY2}];
				2'b11: color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY2}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY2}];
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(buffer1[9])begin
				case(buffer1[11:10])
				2'b00: color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY3}];
				2'b01: color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY3}];
				2'b10: color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY3}];
				2'b11: color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY3}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY3}];
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(buffer1[6])begin
				case(buffer1[8:7])
				2'b00: color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY4}];
				2'b01: color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY4}];
				2'b10: color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY4}];
				2'b11: color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY4}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY4}];
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(buffer1[3])begin
				case(buffer1[5:4])
				2'b00: color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY5}];
				2'b01: color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY5}];
				2'b10: color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY5}];
				2'b11: color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY5}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY5}];
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(buffer1[0])begin
				case(buffer1[2:1])
				2'b00: color_i <= blue0[{(pos_H-bPosX1)*s+pos_V-bPosY6}];
				2'b01: color_i <= blue1[{(pos_H-bPosX1)*s+pos_V-bPosY6}];
				2'b10: color_i <= blue2[{(pos_H-bPosX1)*s+pos_V-bPosY6}];
				2'b11: color_i <= blue3[{(pos_H-bPosX1)*s+pos_V-bPosY6}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX1)*s+pos_V-bPosY6}];
		end
		else color_i <= 8'h0;
	end
	
		// 2nd Buffer Green
	else if(pos_H>=bPosX2 && pos_H<bPosX2+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		    if(buffer2[15])begin
				case(buffer2[17:16])
				2'b00: color_i <= green0[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
				2'b01: color_i <= green1[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
				2'b10: color_i <= green2[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
				2'b11: color_i <= green3[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(buffer2[12])begin
				case(buffer2[14:13])
				2'b00: color_i <= green0[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
				2'b01: color_i <= green1[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
				2'b10: color_i <= green2[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
				2'b11: color_i <= green3[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(buffer2[9])begin
				case(buffer2[11:10])
				2'b00: color_i <= green0[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
				2'b01: color_i <= green1[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
				2'b10: color_i <= green2[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
				2'b11: color_i <= green3[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(buffer2[6])begin
				case(buffer2[8:7])
				2'b00: color_i <= green0[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
				2'b01: color_i <= green1[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
				2'b10: color_i <= green2[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
				2'b11: color_i <= green3[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(buffer2[3])begin
				case(buffer2[5:4])
				2'b00: color_i <= green0[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
				2'b01: color_i <= green1[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
				2'b10: color_i <= green2[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
				2'b11: color_i <= green3[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(buffer2[0])begin
				case(buffer2[2:1])
				2'b00: color_i <= green0[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
				2'b01: color_i <= green1[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
				2'b10: color_i <= green2[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
				2'b11: color_i <= green3[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
		end
		else color_i <= 8'h0;
	end
	
	
	// 3rd Buffer Red
	else if(pos_H>=bPosX3 && pos_H<bPosX3+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		   if(buffer3[15])begin
				case(buffer3[17:16])
				2'b00: color_i <= red0[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
				2'b01: color_i <= red1[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
				2'b10: color_i <= red2[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
				2'b11: color_i <= red3[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(buffer3[12])begin
				case(buffer3[14:13])
				2'b00: color_i <= red0[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
				2'b01: color_i <= red1[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
				2'b10: color_i <= red2[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
				2'b11: color_i <= red3[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(buffer3[9])begin
				case(buffer3[11:10])
				2'b00: color_i <= red0[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
				2'b01: color_i <= red1[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
				2'b10: color_i <= red2[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
				2'b11: color_i <= red3[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(buffer3[6])begin
				case(buffer3[8:7])
				2'b00: color_i <= red0[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
				2'b01: color_i <= red1[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
				2'b10: color_i <= red2[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
				2'b11: color_i <= red3[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(buffer3[3])begin
				case(buffer3[5:4])
				2'b00: color_i <= red0[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
				2'b01: color_i <= red1[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
				2'b10: color_i <= red2[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
				2'b11: color_i <= red3[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(buffer3[0])begin
				case(buffer3[2:1])
				2'b00: color_i <= red0[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
				2'b01: color_i <= red1[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
				2'b10: color_i <= red2[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
				2'b11: color_i <= red3[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
		end
		else color_i <= 8'h0;
	end
	/*
	// 4th Buffer Purple
	else if(pos_H>=bPosX4 && pos_H<bPosX4+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		  if(buffer4[15])begin
				case({buffer4[16],buffer4[17]})
				2'b00: color_i <= purple0[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
				2'b01: color_i <= purple1[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
				2'b10: color_i <= purple2[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
				2'b11: color_i <= purple3[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(buffer4[12])begin
				case({buffer4[13],buffer4[14]})
				2'b00: color_i <= purple0[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
				2'b01: color_i <= purple1[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
				2'b10: color_i <= purple2[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
				2'b11: color_i <= purple3[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(buffer4[9])begin
				case({buffer4[10],buffer4[11]})
				2'b00: color_i <= purple0[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
				2'b01: color_i <= purple1[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
				2'b10: color_i <= purple2[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
				2'b11: color_i <= purple3[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(buffer4[6])begin
			case({buffer4[7],buffer4[8]})
				2'b00: color_i <= purple0[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
				2'b01: color_i <= purple1[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
				2'b10: color_i <= purple2[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
				2'b11: color_i <= purple3[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
				endcase
				end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(buffer4[3])begin
				case({buffer4[4],buffer4[5]})
				2'b00: color_i <= purple0[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
				2'b01: color_i <= purple1[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
				2'b10: color_i <= purple2[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
				2'b11: color_i <= purple3[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(buffer4[0])begin
				case({buffer4[1],buffer4[2]})
				2'b00: color_i <= purple0[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
				2'b01: color_i <= purple1[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
				2'b10: color_i <= purple2[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
				2'b11: color_i <= purple3[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
		end
		else color_i <= 8'h0;
	end
	
	/*
	// 2nd Buffer Blue
	else if(pos_H>=bPosX2 && pos_H<bPosX2+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		    if(buffer2[15])begin
				case({buffer2[16],buffer2[17]})
				2'b00: color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
				2'b01: color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
				2'b10: color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
				2'b11: color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY1}];
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(buffer2[12])begin
				case({buffer2[13],buffer2[14]})
				2'b00: color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
				2'b01: color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
				2'b10: color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
				2'b11: color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY2}];
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(buffer2[9])begin
				case({buffer2[10],buffer2[11]})
				2'b00: color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
				2'b01: color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
				2'b10: color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
				2'b11: color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY3}];
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(buffer2[6])begin
				case({buffer2[7],buffer2[8]})
				2'b00: color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
				2'b01: color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
				2'b10: color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
				2'b11: color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY4}];
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(buffer2[3])begin
				case({buffer2[4],buffer2[5]})
				2'b00: color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
				2'b01: color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
				2'b10: color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
				2'b11: color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY5}];
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(buffer2[0])begin
				case({buffer2[1],buffer2[2]})
				2'b00: color_i <= blue0[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
				2'b01: color_i <= blue1[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
				2'b10: color_i <= blue2[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
				2'b11: color_i <= blue3[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX2)*s+pos_V-bPosY6}];
		end
		else color_i <= 8'h0;
	end
	
	// 3rd Buffer
	else if(pos_H>=bPosX3 && pos_H<bPosX3+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		   if(buffer3[15])begin
				case({buffer3[16],buffer3[17]})
				2'b00: color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
				2'b01: color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
				2'b10: color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
				2'b11: color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY1}];
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(buffer3[12])begin
				case({buffer3[13],buffer3[14]})
				2'b00: color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
				2'b01: color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
				2'b10: color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
				2'b11: color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY2}];
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(buffer3[9])begin
				case({buffer3[10],buffer3[11]})
				2'b00: color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
				2'b01: color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
				2'b10: color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
				2'b11: color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY3}];
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(buffer3[6])begin
				case({buffer3[7],buffer3[8]})
				2'b00: color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
				2'b01: color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
				2'b10: color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
				2'b11: color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY4}];
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(buffer3[3])begin
				case({buffer3[4],buffer3[5]})
				2'b00: color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
				2'b01: color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
				2'b10: color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
				2'b11: color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY5}];
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(buffer3[0])begin
				case({buffer3[1],buffer3[2]})
				2'b00: color_i <= blue0[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
				2'b01: color_i <= blue1[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
				2'b10: color_i <= blue2[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
				2'b11: color_i <= blue3[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX3)*s+pos_V-bPosY6}];
		end
		else color_i <= 8'h0;
	end
	
	// 4th Buffer
	else if(pos_H>=bPosX4 && pos_H<bPosX4+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		  if(buffer4[15])begin
				case({buffer4[16],buffer4[17]})
				2'b00: color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
				2'b01: color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
				2'b10: color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
				2'b11: color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY1}];
		end
		else if	(pos_V>=bPosY2 && pos_V<bPosY2+s) begin
			if(buffer4[12])begin
				case({buffer4[13],buffer4[14]})
				2'b00: color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
				2'b01: color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
				2'b10: color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
				2'b11: color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY2}];
		end
		else if	(pos_V>=bPosY3 && pos_V<bPosY3+s) begin
			if(buffer4[9])begin
				case({buffer4[10],buffer4[11]})
				2'b00: color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
				2'b01: color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
				2'b10: color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
				2'b11: color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY3}];
		end
		else if	(pos_V>=bPosY4 && pos_V<bPosY4+s) begin
			if(buffer4[6])begin
			case({buffer4[7],buffer4[8]})
				2'b00: color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
				2'b01: color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
				2'b10: color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
				2'b11: color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
				endcase
				end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY4}];
		end
		else if	(pos_V>=bPosY5 && pos_V<bPosY5+s) begin
			if(buffer4[3])begin
				case({buffer4[4],buffer4[5]})
				2'b00: color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
				2'b01: color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
				2'b10: color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
				2'b11: color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY5}];
		end
		else if	(pos_V>=bPosY6 && pos_V<bPosY6+s) begin
			if(buffer4[0])begin
				case({buffer4[1],buffer4[2]})
				2'b00: color_i <= blue0[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
				2'b01: color_i <= blue1[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
				2'b10: color_i <= blue2[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
				2'b11: color_i <= blue3[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
				endcase
			end
			else color_i <= blank[{(pos_H-bPosX4)*s+pos_V-bPosY6}];
		end
		else color_i <= 8'h0;
	end
*/
	else begin
			   color_i <= 8'h0;
	end
		

	
end



	assign COLOR = READY ? color_i : 8'h0;

endmodule