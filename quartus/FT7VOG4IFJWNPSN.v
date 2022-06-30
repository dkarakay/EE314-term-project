`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Montvydas Klumbys 
// 
// Create Date:   
// Design Name: 
// Module Name:    VGAInterface 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGAInterface(
    input CLK,							//Clock signal of 25MHz
	 output REFRESH,				//gives trigger when display was refreshed
    input [7:0] COLOUR_IN,			//colour comes that should be displayd
    output reg [7:0] COLOUR_OUT,	//colour goes that was modified to produce colour_in at the rigth moment
    output [9:0] ADDRH,				//Address of the horizontal pixel
    output [8:0] ADDRV,	   		//Address of vertical pixel
    output reg HS,					//Horizontal Synch signal
    output reg VS,						//Vertical Synch signal
	 //output [9:0] VertCounter,
	 //output [9:0] HorzCounter
	// output EndHorzCounter
	input DOWNCOUNTER
    );
	 
	//In many places you will see Value - 1; that minus 1 stands for the fact
	//that we are counting synch times & addresses of pixels starting from
	//0 to max-1 value;
	
	wire [9:0] VertCounter;			//Vertical Synch time Counter
	wire [9:0] HorzCounter;			//Horizontal Synch time Counter
	wire EndHorzTrigger;				//Trigger to detect end of line

	initial begin		//Initial values 
		HS = 0;
		VS = 0;
		COLOUR_OUT = 0;
	end
	

	//Time in horizontal lines
	parameter HorzTimeToPulseWidthEnd	= 10'd96;
	parameter HorzTimeToBackPorchEnd		= 10'd144;
	parameter HorzTimeToDisplayTimeEnd	= 10'd784;
	parameter HorzTimeToFrontPorchEnd	= 10'd800;
	
	//Time in Vertincal lines
	parameter VertTimeToPulseWidthEnd	= 10'd2;			 //2 values for different resolution.. maybe will perform better?
	parameter VertTimeToBackPorchEnd		= 10'd31; //33? //35?
	parameter VertTimeToDisplayTimeEnd	= 10'd511;      //515
	parameter VertTimeToFrontPorchEnd	= 10'd521;		 //525
	
	
	Counter # (
				.MaxValue(HorzTimeToFrontPorchEnd-1),	//max value of synch - 1; for counting from 0 to max-1; 
				.Size(10)										//Size in bits of the max value
			)
	TimeCounterHorizontal(
				.CLK(CLK),										//Clock signal
				.ENABLE(DOWNCOUNTER),									//downcounter which here is the same as original clock signal
				.TRIGGER_OUT(EndHorzTrigger),				//triggers when line ends
				.TIME_COUNT(HorzCounter)					//produces value of horizontal synch
			);		
			
	Counter # (
				.MaxValue(VertTimeToFrontPorchEnd-1),	//max value - 1
				.Size(10)										//Size of max balue in bits
			)			
	TimeCounterVertical(
				.CLK(CLK),										//Clock signal
				.ENABLE(EndHorzTrigger),					//downcounter counts how many lines ended
				.TRIGGER_OUT(REFRESH),						//if vertical line ended -> produces a trigger which signals refresh of the screen
				.TIME_COUNT(VertCounter)					//value of vertical synch timer
			);	
					
	//Checks if produce HS -> LOW or HIGH
	always @(posedge CLK) begin//-1
		if ((HorzCounter < HorzTimeToPulseWidthEnd-1) || (HorzCounter == HorzTimeToFrontPorchEnd-1))//if less that TimeToPulseWidthEnd
			HS <= 1'b0;
		else 
			HS <= 1'b1;
	end
		//Check if VS -> LOW or HIGH
	always @(posedge CLK) begin//-1
		if (EndHorzTrigger)begin
			if ((VertCounter < VertTimeToPulseWidthEnd-1) || (VertCounter == VertTimeToFrontPorchEnd-1))
				VS <= 1'b0;
			else 
				VS <= 1'b1;
		end
	end
	
	//Checks if COLOUR_OUT -> COLOUR_IN or make COLOUR_OUT -> BLACK
	always @(posedge CLK) begin
		if (DOWNCOUNTER) begin
			if (  (HorzCounter > HorzTimeToBackPorchEnd-2)  //-2 for shifting to the left
				&& (HorzCounter <= HorzTimeToDisplayTimeEnd-2)
				&& (VertCounter > VertTimeToBackPorchEnd-1)
				&& (VertCounter <= VertTimeToDisplayTimeEnd-1) )
				COLOUR_OUT <= COLOUR_IN;
			else
				COLOUR_OUT <= 0;
		end
	end

	//Gets address of horizontal pixel
	PixCounter # (
					.AddressSize(10),				//Size of the max value of address
					.TimeToBackPorchEnd (HorzTimeToBackPorchEnd-1),		//lower value of synch timer; -1 corrects the fact that synch starts from 0 to max-1 too;
					.TimeToDisplayTimeEnd (HorzTimeToDisplayTimeEnd-1)	//upper value of synch timer
					)
				HorzPix(
					.CLK(CLK),						//clock signal
					.SYNCH_TIME(HorzCounter),	//gets Synch time
					.ENABLE(DOWNCOUNTER),					//trigger in which here is just CLK
					.PIXCOUNT(ADDRH)				//actual horizontal address of a pixel
					);
	
	//Gets address of vertical pixel; The same as to horizontal but for vertical
	PixCounter # (
					.AddressSize(9),
					.TimeToBackPorchEnd (VertTimeToBackPorchEnd-1),
					.TimeToDisplayTimeEnd (VertTimeToDisplayTimeEnd-1)
					)
				
				VertPix(
					.CLK(CLK),
					.SYNCH_TIME(VertCounter),
					.ENABLE(EndHorzTrigger),	//downcounter checks if line ended
					.PIXCOUNT(ADDRV)
					);
endmodule
