module TopModuleS(
CLOCK_50, VGA_VS, VGA_HS, VGA_CLK,COLOR,
buffer1,buffer2,buffer3,buffer4,inputShow,btnStart,btn0,btn1,swa,
outputReg, readCountBuffer1,read1,readCount1BCD
);

input CLOCK_50;
output VGA_HS, VGA_VS; 
output reg VGA_CLK=0;
output wire [7:0]COLOR;

reg [7:0] color_i;

wire READY;
wire[9:0] pos_H, pos_V;

// 30x30
reg[7:0] blank[0:899];

reg[7:0] blue0[0:899];
reg[7:0] blue1[0:899];
reg[7:0] blue2[0:899];
reg[7:0] blue3[0:899];

/*
reg[7:0] green0[0:899];
reg[7:0] green1[0:899];
reg[7:0] green2[0:899];
reg[7:0] green3[0:899];

reg[7:0] red0[0:899];
reg[7:0] red1[0:899];
reg[7:0] red2[0:899];
reg[7:0] red3[0:899];

reg[7:0] purple0[0:899];
reg[7:0] purple1[0:899];
reg[7:0] purple2[0:899];
reg[7:0] purple3[0:899];
*/

reg[7:0] b1[0:899]; // 30x30
reg[7:0] b2[0:899];
reg[7:0] b3[0:899];
reg[7:0] b4[0:899];
/*
reg[7:0] names[0:1799]; // 90x20
*/


// 24x15
reg[7:0] number0[0:359]; 
reg[7:0] number1[0:359];
/*
reg[7:0] number2[0:359];

reg[7:0] number3[0:359];
reg[7:0] number4[0:359];
reg[7:0] number5[0:359];
reg[7:0] number6[0:359];
reg[7:0] number7[0:359];
reg[7:0] number8[0:359];
reg[7:0] number9[0:359];
*/
reg[7:0] numberBlank[0:359];


// transmitted 60x30
//reg[7:0] textTransmitted[0:1799];
reg[7:0] textInput[0:1799];
reg[7:0] textRead[0:1799];



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

parameter bPosOutY = 100;
parameter bPosInputY = 400;

parameter bPosOutX1 = 300;
parameter bPosOutX2 = 325;
parameter bPosOutX3 = 350;
parameter bPosOutX4 = 375;

parameter bPosTextInputX = 200;
parameter sizeInputX = 60;
parameter sizeInputY = 30;

parameter sizeYNumber = 24;
parameter sizeXNumber = 15;


parameter s=30;

parameter b1Latency = 4;
parameter b2Latency = 3;
parameter b3Latency = 2;
parameter b4Latency = 1;

parameter b1Reliability = 1;
parameter b2Reliability = 2;
parameter b3Reliability = 3;
parameter b4Reliability = 4;

reg [4:0] score1, score2, score3,score4;
reg [2:0] sizeBuff1, sizeBuff2, sizeBuff3,sizeBuff4;
 
reg [4:0] inputReg;
output reg [4:0] inputShow;
output reg [4:0] outputReg,read1;

output reg [18:0] buffer1, buffer2, buffer3, buffer4;
input btnStart,btn0,btn1,swa;

reg [3:0] dummy;
reg pressed;


integer isStartPressed;
integer checkFourValue;
integer data_read;
integer readNow;

output reg [13:0] readCountBuffer1;//, readCountBuffer2, readCountBuffer3, readCountBuffer4;
output wire [15:0] readCount1BCD;

initial begin
score1=0;
score2=0;
score3=0;
score4=0;


inputReg <=0;
inputShow <=0;

dummy <= 0;

pressed = 0;
isStartPressed = 0;
checkFourValue = 0;

sizeBuff1 =0;
sizeBuff2 =0;
sizeBuff3 =0;
sizeBuff4 =0;

data_read=0;

buffer1 <=0;
buffer2 <=0;
buffer3 <=0;
buffer4 <=0;

readNow=0;

$readmemh("ui/buffer/blank.txt", blank);
$readmemh("ui/buffer/blue0.txt", blue0);
$readmemh("ui/buffer/blue1.txt", blue1);
$readmemh("ui/buffer/blue2.txt", blue2);
$readmemh("ui/buffer/blue3.txt", blue3);


$readmemh("ui/text/input.txt", textInput);
$readmemh("ui/text/read.txt", textRead);
//$readmemh("transmitted.txt", textTransmitted);
/*


$readmemh("ui/buffer/green0.txt", green0);
$readmemh("ui/buffer/green1.txt", green1);
$readmemh("ui/buffer/green2.txt", green2);
$readmemh("ui/buffer/green3.txt", green3);

$readmemh("ui/buffer/red0.txt", red0);
$readmemh("ui/buffer/red1.txt", red1);
$readmemh("ui/buffer/red2.txt", red2);
$readmemh("ui/buffer/red3.txt", red3);

$readmemh("ui/buffer/purple0.txt", purple0);
$readmemh("ui/buffer/purple1.txt", purple1);
$readmemh("ui/buffer/purple2.txt", purple2);
$readmemh("ui/buffer/purple3.txt", purple3);
*/


$readmemh("ui/buffer/b1.txt", b1);
$readmemh("ui/buffer/b2.txt", b2);
$readmemh("ui/buffer/b3.txt", b3);
$readmemh("ui/buffer/b4.txt", b4);




$readmemh("ui/numbers/number0.txt", number0);
$readmemh("ui/numbers/number1.txt", number1);
/*
$readmemh("ui/numbers/number2.txt", number2);
$readmemh("ui/numbers/number3.txt", number3);
$readmemh("ui/numbers/number4.txt", number4);
$readmemh("ui/numbers/number5.txt", number5);
$readmemh("ui/numbers/number6.txt", number6);
$readmemh("ui/numbers/number7.txt", number7);
$readmemh("ui/numbers/number8.txt", number8);
$readmemh("ui/numbers/number9.txt", number9);
*/
$readmemh("ui/numbers/blankNumber.txt", numberBlank);


end
always @(posedge CLOCK_50) begin 
	VGA_CLK = ~VGA_CLK;
end

VGA_SyncS SYNC(.vga_CLK(VGA_CLK), .VSync(VGA_VS), .HSync(VGA_HS), .vga_Ready(READY), .pos_H(pos_H), .pos_V(pos_V));

bin2bcd bcdf(.bin(readCountBuffer1), .bcd(readCount1BCD));


always @ (posedge CLOCK_50) begin
	if(swa)readNow = readNow+1;
	else readNow = 0;
	
	//if(readNow == 75000000 && swa)begin
	if(readNow == 60 && swa)begin
		outputReg <= 0;
		
		if(sizeBuff1 == 0) score1<=0;
		if(sizeBuff2 == 0) score2<=0;
		if(sizeBuff3 == 0) score3<=0;
		if(sizeBuff4 == 0) score4<=0;

		if(sizeBuff1 > 0 || sizeBuff2 > 0 || sizeBuff3 > 0 || sizeBuff4 > 0) begin
			
			read1 <= read1 +1;
			if(sizeBuff1 > 0) score1 <= sizeBuff1 <=  3 ?  sizeBuff1*b1Latency+b1Reliability: sizeBuff1*b1Reliability+b1Latency; 		
			if(sizeBuff2 > 0) score2 <= sizeBuff2 <=  3 ?  sizeBuff2*b2Latency+b2Reliability: sizeBuff2*b2Reliability+b2Latency;
			if(sizeBuff3 > 0) score3 <= sizeBuff3 <=  3 ?  sizeBuff3*b3Latency+b3Reliability: sizeBuff3*b3Reliability+b3Latency;
			if(sizeBuff4 > 0) score4 <= sizeBuff4 <=  3 ?  sizeBuff4*b4Latency+b4Reliability: sizeBuff4*b4Reliability+b4Latency;
			
			
			// Read from Buffer 1
			if(score1 >= score2 && score1 >= score3 && score1 >= score4) begin
				outputReg[4] <= 1;
				outputReg[3] <= 0;
				outputReg[2] <= 0;
				outputReg[1] <= buffer1[(sizeBuff1-1)*3+2];
				outputReg[0] <= buffer1[(sizeBuff1-1)*3+1];
			
				buffer1[(sizeBuff1-1)*3]<=0;
				buffer1[(sizeBuff1-1)*3+1]<=0;
				buffer1[(sizeBuff1-1)*3+2]<=0;
				sizeBuff1 = sizeBuff1-1;
				
				readCountBuffer1 <= readCountBuffer1 +1;

			end
			
			// Read from Buffer 4
			else if(score4 >= score1 && score4 >= score2 && score4 >= score3) begin
				outputReg[4] <= 1;
				outputReg[3] <= 1;
				outputReg[2] <= 1;
				outputReg[1] <= buffer4[(sizeBuff4-1)*3+2];
				outputReg[0] <= buffer4[(sizeBuff4-1)*3+1];
			
				buffer4[(sizeBuff4-1)*3]<=0;
				buffer4[(sizeBuff4-1)*3+1]<=0;
				buffer4[(sizeBuff4-1)*3+2]<=0;
				sizeBuff4 = sizeBuff4-1;
				
				//readCountBuffer4 <= readCountBuffer4 +1;
			end
			
			// Read from Buffer 2
			else if(score2 >= score1 && score2 >= score3 && score2 >= score4) begin
				outputReg[4] <= 1;
				outputReg[3] <= 0;
				outputReg[2] <= 1;
				outputReg[1] <= buffer2[(sizeBuff2-1)*3+2];
				outputReg[0] <= buffer2[(sizeBuff2-1)*3+1];
			
				buffer2[(sizeBuff2-1)*3]<=0;
				buffer2[(sizeBuff2-1)*3+1]<=0;
				buffer2[(sizeBuff2-1)*3+2]<=0;
				sizeBuff2 = sizeBuff2-1;
				
				//readCountBuffer2 <= readCountBuffer2 +1;
			end
			
			// Read from Buffer 3
			else if(score3 >= score1 && score3 >= score2 && score3 >= score4) begin
				outputReg[4] <= 1;
				outputReg[3] <= 1;
				outputReg[2] <= 0;
				outputReg[1] <= buffer3[(sizeBuff3-1)*3+2];
				outputReg[0] <= buffer3[(sizeBuff3-1)*3+1];
			
				buffer3[(sizeBuff3-1)*3]<=0;
				buffer3[(sizeBuff3-1)*3+1]<=0;
				buffer3[(sizeBuff3-1)*3+2]<=0;
				sizeBuff3 = sizeBuff3-1;
				
				//readCountBuffer3 <= readCountBuffer3 +1;
			end

		end
		readNow <= 0;

	end
	
	// Take input
	else if (btnStart == 0 && isStartPressed <1) begin
		inputReg=5'b00000;
		isStartPressed <= isStartPressed+1;
	end
	
	else if (isStartPressed == 1) begin
		case ({btn0,btn1,pressed}) 
		
		// No button is pressed
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
				isStartPressed <= 0;
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
	
		// If 4 bits are done
		if (inputReg[4] == 1)begin
			case(inputReg[3:2])
				// 1st Buffer write
				2'b00:begin
					buffer1[17:3]=buffer1[14:0];
					buffer1[2:0] = {inputReg[1:0],1'b1};
					sizeBuff1 <= sizeBuff1 +1;
				end
				
				// 2nd Buffer write
				2'b01:begin
					buffer2[17:3]=buffer2[14:0];
					buffer2[2:0] = {inputReg[1:0],1'b1};
					sizeBuff2 <= sizeBuff2 +1;
				end
				
				// 3rd Buffer write
				2'b10:begin
					buffer3[17:3]=buffer3[14:0];
					buffer3[2:0] = {inputReg[1:0],1'b1};
					sizeBuff3 <= sizeBuff3 +1;
				end
				
				// 4th Buffer write
				2'b11:begin
					buffer4[17:3]=buffer4[14:0];
					buffer4[2:0] = {inputReg[1:0],1'b1};
					sizeBuff4 <= sizeBuff4 +1;
				end
			endcase
			inputShow<=inputReg;
			inputReg=5'b00000;
			isStartPressed <= 0;
			checkFourValue <= 0;
		end
	end 
	
end	




always @(posedge VGA_CLK) begin 	
	
	
	
	// 1st Buffer
	if(pos_H>=bPosX1 && pos_H<bPosX1+s && pos_V>=bPosY1 && pos_V<bPosY6+s)begin
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
	
	/*
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
	*/
	
	// 2nd Buffer Blue
	else 	if(pos_H>=bPosX2 && pos_H<bPosX2+s && pos_V>=bPosY1 && pos_V<bPosY6+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		    if(buffer2[15])begin
				case(buffer2[17:16])
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
				case(buffer2[14:13])
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
				case(buffer2[11:10])
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
				case(buffer2[8:7])
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
				case(buffer2[5:4])
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
				case(buffer2[2:1])
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
	
	
	// 3rd Buffer Blue
	else if(pos_H>=bPosX3 && pos_H<bPosX3+s && pos_V>=bPosY1 && pos_V<bPosY6+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		   if(buffer3[15])begin
				case(buffer3[17:16])
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
				case(buffer3[14:13])
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
				case(buffer3[11:10])
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
				case(buffer3[8:7])
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
				case(buffer3[5:4])
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
				case(buffer3[2:1])
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
	
	// 4th Buffer Purple
	else if(pos_H>=bPosX4 && pos_H<bPosX4+s && pos_V>=bPosY1 && pos_V<bPosY6+s)begin
		if	(pos_V>=bPosY1 && pos_V<bPosY1+s)begin
		  if(buffer4[15])begin
				case(buffer4[17:16])
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
				case(buffer4[14:13])
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
				case(buffer4[11:10])
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
				case(buffer4[8:7])
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
				case(buffer4[5:4])
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
				case(buffer4[2:1])
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
	
	
	

	/*
	else if(pos_H>=300 && pos_H<360 && pos_V>=80 && pos_V<110)begin
		color_i <= textInput[{(pos_H-300)*30+pos_V-80}];
	end
	
	else if(pos_H>=400 && pos_H<460 && pos_V>=80 && pos_V<110)begin
		color_i <= textTransmitted[{(pos_H-400)*30+pos_V-80}];
	end
	*/
	
	// Input Text
	else if (pos_V>=bPosInputY && pos_V<bPosInputY+sizeInputY && pos_H>=bPosTextInputX && pos_H<bPosTextInputX+sizeInputX)begin
		color_i <= textInput[{(pos_H-bPosTextInputX)*sizeInputY+pos_V-bPosInputY}];
	end
	
	// Read Text
	else if (pos_V>=bPosOutY && pos_V<bPosOutY+sizeInputY && pos_H>=bPosTextInputX && pos_H<bPosTextInputX+sizeInputX)begin
		color_i <= textRead[{(pos_H-bPosTextInputX)*sizeInputY+pos_V-bPosOutY}];
	end
	
	// Input Reg
   else if (pos_V>=bPosInputY && pos_V<bPosInputY+sizeYNumber && pos_H>=bPosOutX1 && pos_H<bPosOutX4+sizeXNumber)begin
		if(pos_H>=bPosOutX1 && pos_H<bPosOutX1+sizeXNumber)begin
			if(inputShow[4]) begin
				case(inputShow[3])
				1'b0: color_i <= number0[{(pos_H-bPosOutX1)*sizeYNumber+pos_V-bPosInputY}];
				1'b1: color_i <= number1[{(pos_H-bPosOutX1)*sizeYNumber+pos_V-bPosInputY}];
				endcase
			end else color_i <= numberBlank[{(pos_H-bPosOutX1)*sizeYNumber+pos_V-bPosInputY}];
		end
		
		else if(pos_H>=bPosOutX2 && pos_H<bPosOutX2+sizeXNumber)begin
			if(inputShow[4]) begin
				case(inputShow[2])
				1'b0: color_i <= number0[{(pos_H-bPosOutX2)*sizeYNumber+pos_V-bPosInputY}];
				1'b1: color_i <= number1[{(pos_H-bPosOutX2)*sizeYNumber+pos_V-bPosInputY}];
				endcase
			end else color_i <= numberBlank[{(pos_H-bPosOutX2)*sizeYNumber+pos_V-bPosInputY}];
		end
		
		else if(pos_H>=bPosOutX3 && pos_H<bPosOutX3+sizeXNumber)begin
			if(inputShow[4]) begin
				case(inputShow[1])
				1'b0: color_i <= number0[{(pos_H-bPosOutX3)*sizeYNumber+pos_V-bPosInputY}];
				1'b1: color_i <= number1[{(pos_H-bPosOutX3)*sizeYNumber+pos_V-bPosInputY}];
				endcase
			end else color_i <= numberBlank[{(pos_H-bPosOutX3)*sizeYNumber+pos_V-bPosInputY}];
		end
		
		else if(pos_H>=bPosOutX4 && pos_H<bPosOutX4+sizeXNumber)begin
			if(inputShow[4]) begin
				case(inputShow[0])
				1'b0: color_i <= number0[{(pos_H-bPosOutX4)*sizeYNumber+pos_V-bPosInputY}];
				1'b1: color_i <= number1[{(pos_H-bPosOutX4)*sizeYNumber+pos_V-bPosInputY}];
				endcase
			end else color_i <= numberBlank[{(pos_H-bPosOutX4)*sizeYNumber+pos_V-bPosInputY}];
		end
		
		else color_i <= 8'h0;

	end
	
	// Output Reg
   else if (pos_V>=bPosOutY && pos_V<bPosOutY+sizeYNumber && pos_H>=bPosOutX1 && pos_H<bPosOutX4+sizeXNumber)begin
		if(pos_H>=bPosOutX1 && pos_H<bPosOutX1+sizeXNumber)begin
			if(outputReg[4]) begin
				case(outputReg[3])
				1'b0: color_i <= number0[{(pos_H-bPosOutX1)*sizeYNumber+pos_V-bPosOutY}];
				1'b1: color_i <= number1[{(pos_H-bPosOutX1)*sizeYNumber+pos_V-bPosOutY}];
				endcase
			end else color_i <= numberBlank[{(pos_H-bPosOutX1)*sizeYNumber+pos_V-bPosOutY}];
		end
		
		else if(pos_H>=bPosOutX2 && pos_H<bPosOutX2+sizeXNumber)begin
			if(outputReg[4]) begin
				case(outputReg[2])
				1'b0: color_i <= number0[{(pos_H-bPosOutX2)*sizeYNumber+pos_V-bPosOutY}];
				1'b1: color_i <= number1[{(pos_H-bPosOutX2)*sizeYNumber+pos_V-bPosOutY}];
				endcase
			end else color_i <= numberBlank[{(pos_H-bPosOutX2)*sizeYNumber+pos_V-bPosOutY}];
		end
		
		else if(pos_H>=bPosOutX3 && pos_H<bPosOutX3+sizeXNumber)begin
			if(outputReg[4]) begin
				case(outputReg[1])
				1'b0: color_i <= number0[{(pos_H-bPosOutX3)*sizeYNumber+pos_V-bPosOutY}];
				1'b1: color_i <= number1[{(pos_H-bPosOutX3)*sizeYNumber+pos_V-bPosOutY}];
				endcase
			end else color_i <= numberBlank[{(pos_H-bPosOutX3)*sizeYNumber+pos_V-bPosOutY}];
		end
		
		else if(pos_H>=bPosOutX4 && pos_H<bPosOutX4+sizeXNumber)begin
			if(outputReg[4]) begin
				case(outputReg[0])
				1'b0: color_i <= number0[{(pos_H-bPosOutX4)*sizeYNumber+pos_V-bPosOutY}];
				1'b1: color_i <= number1[{(pos_H-bPosOutX4)*sizeYNumber+pos_V-bPosOutY}];
				endcase
			end else color_i <= numberBlank[{(pos_H-bPosOutX4)*sizeYNumber+pos_V-bPosOutY}];
		end
		
		else color_i <= 8'h0;
	end
	// Transmitted Buffer1 Reg
   /*else if (pos_V>=bPosTransmittedY && pos_V<bPosTransmittedY+sizeYNumber && pos_H>=bPosTransmittedX1 && pos_H<bPosTransmittedX2+sizeXNumber)begin
		if(pos_H>=bPosTransmittedX1 && pos_H<bPosTransmittedX1+sizeXNumber)begin
				
	
	end
	*/
	else begin
	color_i <= 8'h0;
	end
		

	
end



	assign COLOR = READY ? color_i : 8'h0;

endmodule