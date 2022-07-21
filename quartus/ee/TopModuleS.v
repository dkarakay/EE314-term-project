module TopModuleS(CLOCK_50, VGA_VS, VGA_HS, VGA_CLK,COLOR,led1, swa, swb,swc,swd,swe,swf,swg);

input CLOCK_50;
output reg [7:0] led1;
output VGA_HS, VGA_VS; 
output reg VGA_CLK=0;
output wire [7:0]COLOR;
input swa, swb,swc,swd,swe,swf,swg;

reg [7:0] color_i;

wire READY;
wire[9:0] pos_H, pos_V;

reg[7:0] baris[0:9999];
reg[7:0] cengiz[0:9999];
reg[7:0] emre[0:9999];
reg[7:0] fail[0:9999];
reg[7:0] vural[0:9999];
reg[7:0] tomak[0:9999];
reg[7:0] zafer[0:9999];


initial begin
$readmemh("baris.txt", baris);
$readmemh("cengiz.txt", cengiz);
$readmemh("emre.txt", emre);
$readmemh("fail.txt", fail);
$readmemh("vural.txt", vural);
$readmemh("tomak.txt", tomak);
$readmemh("zafer.txt", zafer);

end
always @(posedge CLOCK_50) begin 
	VGA_CLK = ~VGA_CLK;
end

VGA_SyncS SYNC(.vga_CLK(VGA_CLK), .VSync(VGA_VS), .HSync(VGA_HS), .vga_Ready(READY), .pos_H(pos_H), .pos_V(pos_V));



always @(posedge VGA_CLK) begin 	
	
	
	if(pos_H>=150 && pos_H<250 && pos_V>=100 && pos_V<200 && swa) begin
				color_i <= baris[{(pos_H-150)*100+pos_V-100}];

	end
	
	else if(pos_H>=300 && pos_H<450 && pos_V>=100 && pos_V<200 && swb) begin
				color_i <= cengiz[{(pos_H-300)*100+pos_V-100}];

	end
	
	else if(pos_H>=500 && pos_H<600 && pos_V>=100 && pos_V<200 && swc) begin
				color_i <= emre[{(pos_H-500)*100+pos_V-100}];

	end
	
	else if(pos_H>=650 && pos_H<800 && pos_V>=100 && pos_V<200 && swd) begin
				color_i <= fail[{(pos_H-650)*100+pos_V-100}];

	end
		
	else if(pos_H>=200 && pos_H<300 && pos_V>=300 && pos_V<400 && swe) begin
				color_i <= vural[{(pos_H-200)*100+pos_V-300}];

	end
	
	else if(pos_H>=400 && pos_H<500 && pos_V>=300 && pos_V<400 && swf) begin
				color_i <= zafer[{(pos_H-400)*100+pos_V-300}];

	end
	
	else if(pos_H>=600 && pos_H<700 && pos_V>=300 && pos_V<400 && swg) begin
				color_i <= tomak[{(pos_H-600)*100+pos_V-300}];

	end
	else begin
			   color_i <= 8'h0;
	end
		

	
end



	assign COLOR = READY ? color_i : 8'h0;

endmodule