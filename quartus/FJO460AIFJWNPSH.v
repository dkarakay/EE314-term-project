`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Montvydas Klumbys 
// 
// Create Date:    
// Design Name: 
// Module Name:    Counter 
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
module Counter(
	CLK, 								//clock signal
	ENABLE,							//trigger input
	TRIGGER_OUT,					//trigger output
	TIME_COUNT						//counts synch time
    );
	
	parameter MaxValue  = 799;	//parameters for the max value
	parameter Size = 10;			//and the size required for that value
	parameter InitialValue = MaxValue;
	
	input CLK;						//define as input
	input ENABLE;					//the same
	output reg TRIGGER_OUT;		//output and register
	output reg [Size - 1: 0] TIME_COUNT;	//bit array for holding bigger values & output & register
	
	initial begin					//initial values for simulation purpose
		TRIGGER_OUT = 0;
		TIME_COUNT = InitialValue;
	end
	
	always@(posedge CLK) begin
		if (ENABLE) begin							//if enabled counting
			if (TIME_COUNT == MaxValue)		//if max value reached -> reset
				TIME_COUNT <= 0;
			else
				TIME_COUNT <= TIME_COUNT + 1;	//else add one
		end
	end

	always @(posedge CLK) begin//-1
		if (ENABLE && (TIME_COUNT == MaxValue-1)) 	//if enabled counting & max value reached
			TRIGGER_OUT <= 1;	
		else													//then trigger out a pulse for one clock cycle
			TRIGGER_OUT <= 0;								//else don trigger pulse
	end
endmodule
