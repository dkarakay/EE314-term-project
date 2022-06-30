`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Montvydas Klumbys
// 
// Create Date: 
// Design Name: 
// Module Name:    PixCounter 
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
module PixCounter(
	CLK, 					//clock signal
	SYNCH_TIME,			//value of synch time
	PIXCOUNT,			//address of pixel
	ENABLE				//downcounter
    );
	
	parameter AddressSize = 10;				//size of the max value in the address
	parameter TimeToBackPorchEnd = 5;//30;		//start point of displaying
	parameter TimeToDisplayTimeEnd	= 10;//510;//end point of displaying
	
	input CLK;					//defined as input
	input ENABLE;				//defined as input
	input [9:0]SYNCH_TIME;	//synch time now
	output reg [AddressSize - 1: 0] PIXCOUNT;//address of the pixel
	
	initial begin				//initial value for the simulation
		PIXCOUNT = 0;
	end
	
	//Another way of calculating the Address of a pixel
	//but requires substraction of more than one bit
	//thus uses more resources and still does the same function
	/*
	always@(posedge CLK) begin
		if (ENABLE) begin
			if ((SYNCH_TIME > TimeToBackPorchEnd)
				&& (SYNCH_TIME <= TimeToDisplayTimeEnd))
				PIXCOUNT <= SYNCH_TIME - TimeToBackPorchEnd - 1;
			else
				PIXCOUNT <= 0;
		end
	end
	*/
	
	always@(posedge CLK) begin//+1
	if (ENABLE) begin	//if triggered counting & synch time is in between displaying area 
			if ((SYNCH_TIME > TimeToBackPorchEnd) && (SYNCH_TIME <= TimeToDisplayTimeEnd-1))
				PIXCOUNT <= PIXCOUNT + 1;	//increment address
			else
				PIXCOUNT <= 0;					//else reset address to 0
		end
	end
	
endmodule


				
