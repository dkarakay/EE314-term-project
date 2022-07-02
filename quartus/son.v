module son(clk,btnStart,btn0,btn1,inputReg,buffer1,buffer2,buffer3,buffer4);

input clk;
input btnStart;
input btn0;
input btn1;

reg [3:0] dummy;

reg pressed;
integer isStartPressed,isBtn0Pressed,isBtn1Pressed;
integer checkFourValue;

integer indexb1, indexb2, indexb3,indexb4;

output reg [4:0] inputReg;

output reg [18:0] buffer1, buffer2, buffer3, buffer4;

initial begin
inputReg <=0;
dummy <= 0;
pressed = 0;
isStartPressed = 0;
checkFourValue = 0;
indexb1 =0;
end



always @ (posedge clk) begin

	if (btnStart == 0 && isStartPressed <3) begin
		inputReg <=0;
		isStartPressed <= isStartPressed+1;
	end
	
	else if (isStartPressed == 3) begin

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
	
	if (inputReg[4])begin
		case({inputReg[3],inputReg[2]})
			
			// 1st Buffer
			2'b00:begin
				case({inputReg[1],inputReg[0]})
					2'b00:	begin
					buffer1[indexb1+1] = 0;
					buffer1[indexb1+2] = 0;
					end
					
					2'b01:	begin
					buffer1[indexb1+1] = 0;
					buffer1[indexb1+2] = 1;
					end

					2'b10:	begin
					buffer1[indexb1+1] = 1;
					buffer1[indexb1+2] = 0;
					end
					
					2'b11:	begin
					buffer1[indexb1+1] = 1;
					buffer1[indexb1+2] = 1;
					end
				endcase
				buffer1[indexb1] = 1;
				indexb1 = indexb1 +3;
			end
			
			// 2nd Buffer
			2'b01:begin
				case({inputReg[1],inputReg[0]})
					2'b00:	begin
					buffer2[indexb2+1] = 0;
					buffer2[indexb2+2] = 0;
					end
					
					2'b01:	begin
					buffer2[indexb2+1] = 0;
					buffer2[indexb2+2] = 1;
					end

					2'b10:	begin
					buffer2[indexb2+1] = 1;
					buffer2[indexb2+2] = 0;
					end
					
					2'b11:	begin
					buffer2[indexb2+1] = 1;
					buffer2[indexb2+2] = 1;
					end
				
				endcase
				buffer2[indexb2] = 1;
				indexb2 = indexb2 +3;
			end
			
			// 3rd Buffer
			2'b10:begin
				case({inputReg[1],inputReg[0]})
					2'b00:	begin
					buffer3[indexb3+1] = 0;
					buffer3[indexb3+2] = 0;
					end
					
					2'b01:	begin
					buffer3[indexb3+1] = 0;
					buffer3[indexb3+2] = 1;
					end

					2'b10:	begin
					buffer3[indexb3+1] = 1;
					buffer3[indexb3+2] = 0;
					end
					
					2'b11:	begin
					buffer3[indexb3+1] = 1;
					buffer3[indexb3+2] = 1;
					end
				
				endcase
				buffer3[indexb3] = 1;
				indexb3 = indexb3 +3;
			end
			
			// 4th Buffer
			2'b11:begin
				case({inputReg[1],inputReg[0]})
					2'b00:	begin
					buffer4[indexb4+1] = 0;
					buffer4[indexb4+2] = 0;
					end
					
					2'b01:	begin
					buffer4[indexb4+1] = 0;
					buffer4[indexb4+2] = 1;
					end

					2'b10:	begin
					buffer4[indexb4+1] = 1;
					buffer4[indexb4+2] = 0;
					end
					
					2'b11:	begin
					buffer4[indexb4+1] = 1;
					buffer4[indexb4+2] = 1;
					end
				
				endcase
				buffer4[indexb4] = 1;
				indexb4 = indexb4 +3;
			end
		endcase
	end
	
end	
		
				
end
endmodule