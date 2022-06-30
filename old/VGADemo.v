module VGADemo(clk,vga_red, vga_blue, vga_green, hsync_out, vsync_out, clk_25);
	input clk;
	output hsync_out;
	output vsync_out;
   wire inDisplayArea;
   wire [9:0] CounterX;
	output reg clk_25;
	output reg [7:0] vga_red, vga_blue, vga_green;

	initial begin
		clk_25 = 1'b0;
		vga_red = 8'h05;
		vga_blue = 8'h04;
		vga_green = 8'h07;	
   end
	 
	always @(posedge clk) begin 
	clk_25 = ~clk_25;
	end
	 
    hvsync_generator hvsync(
      .clk(clk_25),
      .vga_h_sync(hsync_out),
      .vga_v_sync(vsync_out),
      .CounterX(CounterX),
      //.CounterY(CounterY),
      .inDisplayArea(inDisplayArea)
    );
	 
	

    always @(posedge clk_25)
    begin
      if (inDisplayArea)
        vga_green <= CounterX[9:6] == 8'h09;
      else // if it's not to display, go dark
        vga_green <= 8'h05;
    end

endmodule