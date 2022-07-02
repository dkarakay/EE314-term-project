`timescale 1ns / 1ps

//Display Menu and Shopping Interface 640x480 @ 60 fps

module Project8(
	input [3:0] KEY,		//Buttons
	input [1:0] SW,		//Switches
	input ENTER,			//Switch
	input clk50,           // 50 MHz
	output o_hsync,      // horizontal sync
	output o_vsync,	     // vertical sync
	output o_vga_clk,		//vga clock
	output [7:0] o_color	//vga colors
);

	reg [9:0] counter_x = 1;  // horizontal counter
	reg [9:0] counter_y = 1;  // vertical counter
	reg [7:0] color;
	
	reg [11:0] highlight;	//registers which indicates highlighted items 
	reg [5:0] dhighlight;	//registers which indicates highlighted items in the shopping list

	reg [2:0] barkod0;	//fisrt digit of the ID
	reg [2:0] barkod1;	//second
	reg [2:0] barkod2;	//third
	reg [2:0] barkod3;	//fourth
	reg [2:0] barkodQuantity;	//quantity entered for the selected barcode
	
	//ID Codes
	//Apple => 3133
	//Banana => 3124
	//Carrot => 3123
	//Corn => 3122
	//Grapes => 3132
	//Kiwi => 3131
	//Orange => 4131
	//Peach =>3121
	//Pepper =>4134
	//Pineapple => 3214
	//Potato => 4132
	//Tomato =>4133
	
	reg [3:0] pKEY;	//previous KEY values
	reg [1:0] pSW;		//previouse SW values

	reg [2:0] quantity;	//quantity entered for the selected item in navigation mode
	reg [3:0] listedItem;	//number of items in shopping list
	integer i;	//integer for "for loops"
	reg qFlag;
	reg qFlagNav;
	reg delFlag;
	reg [23:0] shoppingItems;	
	reg [17:0] shoppingQuantity;
	reg [23:0] remainingItemsDown, remainingItemsUp;
	reg [17:0] remainingQuantityDown, remainingQuantityUp;
	reg [12:0] itemPrice [0:5];
	reg [3:0] a [0:5];
	reg [3:0] b [0:5];
	reg [3:0] c [0:5];
	reg [3:0] d [0:5];
	reg [15:0] t;
	reg [4:0] tFinal [0:4];
	reg totalFlag;
	
	//registers to store image data
	reg [7:0] apple_data [0:6399];
	reg [7:0] banana_data [0:6399];
	reg [7:0] carrot_data [0:6399];
	reg [7:0] corn_data [0:6399];
	reg [7:0] grapes_data [0:6399];
	reg [7:0] kiwi_data [0:6399];
	reg [7:0] orange_data [0:6399];
	reg [7:0] peach_data [0:6399];
	reg [7:0] pepper_data [0:6399];
	reg [7:0] pineapple_data [0:6399];
	reg [7:0] potato_data [0:6399];
	reg [7:0] tomato_data [0:6399];
	reg [7:0] appleP_data [0:1079];
	reg [7:0] bananaP_data [0:1079];
	reg [7:0] carrotP_data [0:1079];
	reg [7:0] cornP_data [0:1079];
	reg [7:0] grapesP_data [0:1079];
	reg [7:0] kiwiP_data [0:1079];
	reg [7:0] orangeP_data [0:1079];
	reg [7:0] peachP_data [0:1079];
	reg [7:0] pepperP_data [0:1079];
	reg [7:0] pineappleP_data [0:1079];
	reg [7:0] potatoP_data [0:1079];
	reg [7:0] tomatoP_data [0:1079];
	reg [7:0] groceries_data [0:9099];
	reg [7:0] groupLogo_data [0:3525];
	reg [7:0] item_data [0:1793];
	reg [7:0] shoppingList_data [0:8249];
	reg [7:0] total_data [0:1274];
	
	reg [7:0] appleShop [0:1052];
	reg [7:0] bananaShop [0:1052];
	reg [7:0] carrotShop [0:1052];
	reg [7:0] cornShop [0:1052];
	reg [7:0] grapesShop [0:1052];
	reg [7:0] kiwiShop [0:1052];
	reg [7:0] orangeShop [0:1052];
	reg [7:0] peachShop [0:1052];
	reg [7:0] pepperShop [0:1052];
	reg [7:0] pineappleShop [0:1052];
	reg [7:0] potatoShop [0:1052];
	reg [7:0] tomatoShop [0:1052];
	
	reg [7:0] zero [0:199];
	reg [7:0] one [0:199];
	reg [7:0] two [0:199];
	reg [7:0] three [0:199];
	reg [7:0] four [0:199];
	reg [7:0] five [0:199];
	reg [7:0] six [0:199];
	reg [7:0] seven [0:199];
	reg [7:0] eight [0:199];
	reg [7:0] nine [0:199];
	reg [7:0] dot [0:99];
	
	reg [7:0] totalDot [0:417];
	reg [7:0] totalZero [0:721];
	reg [7:0] totalOne [0:721];
	reg [7:0] totalTwo [0:721];
	reg [7:0] totalThree [0:721];
	reg [7:0] totalFour [0:721];
	reg [7:0] totalFive [0:721];
	reg [7:0] totalSix [0:721];
	reg [7:0] totalSeven [0:721];
	reg [7:0] totalEight [0:721];
	reg [7:0] totalNine [0:721];
	reg [7:0] totalT [0:721];
	reg [7:0] totalL [0:721];

	
	//Prices*100 of the goods
	parameter appleP=100;
	parameter bananaP=250;
	parameter carrotP=70;
	parameter cornP=245;
	parameter grapesP=400;
	parameter kiwiP=350;
	parameter orangeP=250;
	parameter peachP=200;
	parameter pepperP=40;
	parameter pineappleP=995;
	parameter potatoP=50;
	parameter tomatoP=75;
		
	//dimensions of the images on the rigth part of the screen
	parameter food1XY = 7'd80;
	parameter foodPriceX = 6'd54;
	parameter foodPriceY = 5'd20;
	
	//vga parameters for 640x480 60Hz display
	parameter h_counter_max = 800;
	parameter h_sync_pulse = 96;
	parameter h_back_porch = 48;
	parameter h_front_porch = 16;
	parameter h_visible_area = 640;
	
	parameter v_counter_max = 525;
	parameter v_sync_pulse = 2;
	parameter v_back_porch = 33;
	parameter v_front_porch = 10;
	parameter v_visible_area = 480;
	
	wire clk25;

	// clk divider 50 MHz to 25 MHz
	pll pll1(.refclk(clk50), .outclk_0(clk25));
	
	//Alternative way to obtain 25 Mhz clock
	/* reg clk25;
	initial begin
		clk25=0;
	end
	
	always @ (posedge clk50)
		begin
			clk25 <= ~clk25;
		end*/
	
	//assign 25 Mhz clock to the VGA clock output in order to have a synchronized communication
	assign o_vga_clk=clk25;
	
	initial begin
		//initial values for the defined variables & registers
		pKEY=4'b1111;
		pSW=3'b000;
		quantity = 3'b000;
		barkodQuantity = 3'b000;
		listedItem = 4'b0000;
		qFlag = 0;
		totalFlag = 0;
		delFlag = 0;
		t = 15'd0;
		barkod0 = 3'b000;
		barkod1 = 3'b000;
		barkod2 = 3'b000;
		barkod3 = 3'b000;
		//$readmemh reads the RGB values of an image from a .list file to a register
		$readmemh ("apple.list", apple_data);
		$readmemh ("banana.list", banana_data);
		$readmemh ("carrot.list", carrot_data);
		$readmemh ("corn.list", corn_data);
		$readmemh ("grapes.list", grapes_data);
		$readmemh ("kiwi.list", kiwi_data);
		$readmemh ("orange.list", orange_data);
		$readmemh ("peach.list", peach_data);
		$readmemh ("pepper.list", pepper_data);
		$readmemh ("pineapple.list", pineapple_data);
		$readmemh ("potato.list", potato_data);
		$readmemh ("tomato.list", tomato_data);
		$readmemh ("apple_price.list", appleP_data);
		$readmemh ("banana_price.list", bananaP_data);
		$readmemh ("carrot_price.list", carrotP_data);
		$readmemh ("corn_price.list", cornP_data);
		$readmemh ("grapes_price.list", grapesP_data);
		$readmemh ("kiwi_price.list", kiwiP_data);
		$readmemh ("orange_price.list", orangeP_data);
		$readmemh ("peach_price.list", peachP_data);
		$readmemh ("pepper_price.list", pepperP_data);
		$readmemh ("pineapple_price.list", pineappleP_data);
		$readmemh ("potato_price.list", potatoP_data);
		$readmemh ("tomato_price.list", tomatoP_data);
		$readmemh ("groceries.list", groceries_data);
		$readmemh ("groupLogo.list", groupLogo_data);
		$readmemh ("item.list", item_data);
		$readmemh ("shoppingList.list", shoppingList_data);
		$readmemh ("total.list", total_data);
		$readmemh ("appleShop.list", appleShop);
		$readmemh ("bananaShop.list", bananaShop);
		$readmemh ("carrotShop.list", carrotShop);
		$readmemh ("cornShop.list", cornShop);
		$readmemh ("grapesShop.list", grapesShop);
		$readmemh ("kiwiShop.list", kiwiShop);
		$readmemh ("orangeShop.list", orangeShop);
		$readmemh ("peachShop.list", peachShop);
		$readmemh ("pepperShop.list", pepperShop);
		$readmemh ("pineappleShop.list", pineappleShop);
		$readmemh ("potatoShop.list", potatoShop);
		$readmemh ("tomatoShop.list", tomatoShop);
		$readmemh ("zero.list", zero);
		$readmemh ("one.list", one);
		$readmemh ("two.list", two);
		$readmemh ("three.list", three);
		$readmemh ("four.list", four);
		$readmemh ("five.list", five);
		$readmemh ("six.list", six);
		$readmemh ("seven.list", seven);
		$readmemh ("eight.list", eight);
		$readmemh ("nine.list", nine);
		$readmemh ("dot.list", dot);
		$readmemh ("totalDot.list", totalDot);
		$readmemh ("totalL.list", totalL);
		$readmemh ("totalT.list", totalT);
		$readmemh ("totalNine.list", totalNine);
		$readmemh ("totalEight.list", totalEight);
		$readmemh ("totalSeven.list", totalSeven);
		$readmemh ("totalSix.list", totalSix);
		$readmemh ("totalFive.list", totalFive);
		$readmemh ("totalFour.list", totalFour);
		$readmemh ("totalThree.list", totalThree);
		$readmemh ("totalTwo.list", totalTwo);
		$readmemh ("totalOne.list", totalOne);
		$readmemh ("totalZero.list", totalZero);
	end
	
	// counter and sync generation
	always @(posedge clk25)  // horizontal counter
		begin 
			if (counter_x < h_counter_max)
				counter_x <= counter_x + 1;  // horizontal counter (including off-screen horizontal 160 pixels) total of 800 pixels 
			else
				counter_x <= 1;              
		end
		
	always @ (posedge clk25)  // vertical counter
		begin 
			if (counter_x == h_counter_max)  // only counts up 1 count after horizontal finishes 800 counts
				begin
					if (counter_y < v_counter_max)  // vertical counter (including off-screen vertical 45 pixels) total of 525 pixels
						counter_y <= counter_y + 1;
					else
						counter_y <= 1;              
				end
		end  
 

	// hsync and vsync output assignment
	assign o_hsync = (counter_x >= 1 && counter_x <= h_sync_pulse) ? 1:0;  // hsync high for 96 counts                                                 
	assign o_vsync = (counter_y >= 1 && counter_y <= v_sync_pulse) ? 1:0;   // vsync high for 2 counts

	
	always @ (posedge clk25)
		begin
			if(pSW != SW) // this statement is true if the state of switches are changed
				begin
					case(SW)// determine the initial conditions of the registers based on the current operation mode. (state of the switches determines the operation mode)
						2'b00: begin // ID Code Mode
							highlight = 12'b000000000000;
							dhighlight = 6'b000000;
						end
						
						2'b01: begin //Navigation Mode
							highlight = 12'b000000000001;
							dhighlight = 6'b000000;
							barkod0 = 3'b000;
							barkod1 = 3'b000;
							barkod2 = 3'b000;
							barkod3 = 3'b000;
							t = t;
							itemPrice[0] = itemPrice[0];
							itemPrice[1] = itemPrice[1];
							itemPrice[2] = itemPrice[2];
							itemPrice[3] = itemPrice[3];
							itemPrice[4] = itemPrice[4];
							itemPrice[5] = itemPrice[5];
							listedItem = listedItem;
												
						end
						
						2'b10,
						2'b11: begin // Deletion Mode
							highlight = 12'b000000000000;
							dhighlight = 6'b000001;
							barkod0 = 3'b000;
							barkod1 = 3'b000;
							barkod2 = 3'b000;
							barkod3 = 3'b000;
							t = t;
							itemPrice[0] = itemPrice[0];
							itemPrice[1] = itemPrice[1];
							itemPrice[2] = itemPrice[2];
							itemPrice[3] = itemPrice[3];
							itemPrice[4] = itemPrice[4];
							itemPrice[5] = itemPrice[5];
							listedItem = listedItem;
						end
						
						default: begin
							highlight = 12'b000000000000;
							dhighlight = 6'b000000;
						end
						
					endcase
					
				end
				
			case(SW) // Determine the function of the keys based on the operation mode
				2'b00: begin // ID Code Mode
										
					if (barkod0 == 3'b000) 
						begin
							if(!KEY[0] && pKEY[0])
								barkod0 = 3'b001;
							else if(!KEY[1] && pKEY[1])
								barkod0 = 3'b010;
							else if(!KEY[2] && pKEY[2])
								barkod0 = 3'b011;
							else if(!KEY[3] && pKEY[3])
								barkod0 = 3'b100;	
						end	
					else if ((barkod0 != 3'b000) && (barkod1 == 3'b000)) 
						begin
							if(!KEY[0] && pKEY[0])
								barkod1 = 3'b001;
							else if(!KEY[1] && pKEY[1])
								barkod1 = 3'b010;
							else if(!KEY[2] && pKEY[2])
								barkod1 = 3'b011;
							else if(!KEY[3] && pKEY[3])
								barkod1 = 3'b100;	
						end
					else if ((barkod0 != 3'b000) && (barkod1 != 3'b000) && (barkod2 == 3'b000)) 
						begin
							if(!KEY[0] && pKEY[0])
								barkod2 = 3'b001;
							else if(!KEY[1] && pKEY[1])
								barkod2 = 3'b010;
							else if(!KEY[2] && pKEY[2])
								barkod2 = 3'b011;
							else if(!KEY[3] && pKEY[3])
								barkod2 = 3'b100;	
						end
					else if ((barkod0 != 3'b000) && (barkod1 != 3'b000) && (barkod2 != 3'b000) && (barkod3 == 3'b000)) 
						begin
							if(!KEY[0] && pKEY[0])
								barkod3 = 3'b001;
							else if(!KEY[1] && pKEY[1])
								barkod3 = 3'b010;
							else if(!KEY[2] && pKEY[2])
								barkod3 = 3'b011;
							else if(!KEY[3] && pKEY[3])
								barkod3 = 3'b100;	
						end
						
					else if ((barkod0 != 3'b000) && (barkod1 != 3'b000) && (barkod2 != 3'b000) && (barkod3 != 3'b000))
						begin
							if( (pKEY[0] == 1) && (KEY[0] == 0) )
								begin
									barkodQuantity = 3'b001;
									shoppingQuantity = shoppingQuantity + (3'b001 << listedItem*3);
									qFlag = 1;
								end
							else if ( (pKEY[1] == 1) && (KEY[1] == 0) )
								begin
									barkodQuantity = 3'b010;
									shoppingQuantity = shoppingQuantity + (3'b010 << listedItem*3);
									qFlag = 1;
								end
							else if ( (pKEY[2] == 1) && (KEY[2] == 0) )
								begin
									barkodQuantity = 3'b011;
									shoppingQuantity = shoppingQuantity + (3'b011 << listedItem*3);
									qFlag = 1;
								end
							else if ( (pKEY[3] == 1) && (KEY[3] == 0) )
								begin
									barkodQuantity = 3'b100;
									shoppingQuantity = shoppingQuantity + (3'b100 << listedItem*3);
									qFlag = 1;
								end
						end
					
					
					if ((barkod0 == 3'b100) && (barkod1 == 3'b000 || barkod1 == 3'b001) && (barkod2 == 3'b000 || barkod2 == 3'b011) && (barkod3 == 3'b000))
						highlight = 12'b110101000000;
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b000) && (barkod2 == 3'b000) && (barkod3 == 3'b000))
						highlight = 12'b001010111111;
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b001) && (barkod2 == 3'b000) && (barkod3 == 3'b000))
						highlight = 12'b000010111111;						
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b001) && (barkod2 == 3'b010) && (barkod3 == 3'b000))
						highlight = 12'b000010001110;						
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b001) && (barkod2 == 3'b011) && (barkod3 == 3'b000))
						highlight = 12'b000000110001;
						
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b010) && (barkod2 == 3'b000 || barkod2 == 3'b001) && (barkod3 == 3'b000 || barkod3 == 3'b100))
						highlight = 12'b001000000000;
						
					else if ((barkod0 == 3'b100) && (barkod1 == 3'b001) && (barkod2 == 3'b011) && (barkod3 == 3'b011))
						highlight = 12'b100000000000;
					else if ((barkod0 == 3'b100) && (barkod1 == 3'b001) && (barkod2 == 3'b011) && (barkod3 == 3'b010))
						highlight = 12'b010000000000;
					else if ((barkod0 == 3'b100) && (barkod1 == 3'b001) && (barkod2 == 3'b011) && (barkod3 == 3'b100))
						highlight = 12'b000100000000;
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b001) && (barkod2 == 3'b010) && (barkod3 == 3'b001))
						highlight = 12'b000010000000;
					else if ((barkod0 == 3'b100) && (barkod1 == 3'b001) && (barkod2 == 3'b011) && (barkod3 == 3'b001))
						highlight = 12'b000001000000;
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b001) && (barkod2 == 3'b011) && (barkod3 == 3'b001))
						highlight = 12'b000000100000;
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b001) && (barkod2 == 3'b011) && (barkod3 == 3'b010))
						highlight = 12'b000000010000;
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b001) && (barkod2 == 3'b010) && (barkod3 == 3'b010))
						highlight = 12'b000000001000;
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b001) && (barkod2 == 3'b010) && (barkod3 == 3'b011))
						highlight = 12'b000000000100;
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b001) && (barkod2 == 3'b010) && (barkod3 == 3'b100))
						highlight = 12'b000000000010;
					else if ((barkod0 == 3'b011) && (barkod1 == 3'b001) && (barkod2 == 3'b011) && (barkod3 == 3'b011))
						highlight = 12'b000000000001;
					else if ((barkod0 == 3'b001) && (barkod1 == 3'b001) && (barkod2 == 3'b001) && (barkod3 == 3'b001))
						begin
							totalFlag = 1;
							barkod0 = 3'b000;
							barkod1 = 3'b000;
							barkod2 = 3'b000;
							barkod3 = 3'b000;
						end
					else if ((barkod0 == 3'b010) && (barkod1 == 3'b010) && (barkod2 == 3'b010) && (barkod3 == 3'b010))
						begin
							barkod0 = 3'b000;
							barkod1 = 3'b000;
							barkod2 = 3'b000;
							barkod3 = 3'b000;
							quantity = 3'b000;
							barkodQuantity = 3'b000;
							listedItem = 4'b0000;
							totalFlag = 0;
							t = 16'd0;
							shoppingItems = 24'd0;
							shoppingQuantity = 18'd0;
							itemPrice[0] = 13'd0;
							itemPrice[1] = 13'd0;
							itemPrice[2] = 13'd0;
							itemPrice[3] = 13'd0;
							itemPrice[4] = 13'd0;
							itemPrice[5] = 13'd0;
						end

					
					
					
					
					if (qFlag == 1) // If a quantity is entered execute the following code
						begin
							case(highlight)// 
								12'b000000000001:
									begin
										shoppingItems = shoppingItems + (4'b0001 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*appleP;
										t = t + barkodQuantity*appleP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b000000000010:
									begin
										shoppingItems = shoppingItems + (4'b0010 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*bananaP;
										t = t + barkodQuantity*bananaP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b000000000100:
									begin
										shoppingItems = shoppingItems + (4'b0011 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*carrotP;
										t = t + barkodQuantity*carrotP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b000000001000:
									begin
										shoppingItems = shoppingItems + (4'b0100 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*cornP;
										t = t + barkodQuantity*cornP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b000000010000:
									begin
										shoppingItems = shoppingItems + (4'b0101 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*grapesP;
										t = t + barkodQuantity*grapesP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b000000100000:
									begin
										shoppingItems = shoppingItems + (4'b0110 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*kiwiP;
										t = t + barkodQuantity*kiwiP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b000001000000:								
									begin
										shoppingItems = shoppingItems + (4'b0111 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*orangeP;
										t = t + barkodQuantity*orangeP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b000010000000:
									begin
										shoppingItems = shoppingItems + (4'b1000 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*peachP;
										t = t + barkodQuantity*peachP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b000100000000:
									begin
										shoppingItems = shoppingItems + (4'b1001 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*pepperP;
										t = t + barkodQuantity*pepperP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b001000000000:
									begin
										shoppingItems = shoppingItems + (4'b1010 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*pineappleP;
										t = t + barkodQuantity*pineappleP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b010000000000:
									begin
										shoppingItems = shoppingItems + (4'b1011 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*potatoP;
										t = t + barkodQuantity*potatoP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
								12'b100000000000:
									begin
										shoppingItems = shoppingItems + (4'b1100 << listedItem*4);
										itemPrice[listedItem] = barkodQuantity*tomatoP;
										t = t + barkodQuantity*tomatoP;
										listedItem = listedItem + 1;
										barkod0 = 3'b000;
										barkod1 = 3'b000;
										barkod2 = 3'b000;
										barkod3 = 3'b000;
									end
							endcase
							
						end
											
				end
	
				2'b01: begin//Navigation Mode
					
					if(ENTER==0)//If ENTER == 0, buttons are used to navigate through the items
						begin
							if( (pKEY[0] == 1) && (KEY[0] == 0) )//right
								begin
									if(highlight[11]==1)
											highlight = 12'b000000000001;//go to the first item from the last
									else
											highlight = (highlight<<1);//left shift by 1 to go right
								end
								
							else if( (pKEY[3] == 1) && (KEY[3] == 0) )//left
								begin
									if(highlight[0]==1)
										highlight = 12'b100000000000;//go to the last item from the first
									else
										highlight = (highlight>>1);//right shift by 1 to go left
								end
								
							else if( (pKEY[1] == 1) && (KEY[1] == 0) )//uo
								begin
									if( (highlight[0]==1) || (highlight[1]==1) || (highlight[2]==1) || (highlight[3]==1) )
										highlight = (highlight<<8);//go to the last row from the first row
									else
										highlight = (highlight>>4);//right shift by 4 to go up
								end
								
							else if( (pKEY[2] == 1) && (KEY[2] == 0) )//down
								begin
									if( (highlight[8]==1) || (highlight[9]==1) || (highlight[10]==1) || (highlight[11]==1) )
										highlight = (highlight>>8);//go to the first row from the last row
									else
										highlight = (highlight<<4);//left shift by 4 to go down
								end
						end
					else if(ENTER==1)//if ENTER==1, store the quantity
						begin
							if( (pKEY[0] == 1) && (KEY[0] == 0) )
								begin
									quantity = 3'b001;//quantity is 1
									shoppingQuantity = shoppingQuantity + (3'b001 << listedItem*3);//store the 3 bit quantiy in an 18 bit register by bit shifting
									qFlagNav = 1;//set the flag to high if a quantity is entered
								end
							else if ( (pKEY[1] == 1) && (KEY[1] == 0) )
								begin
									quantity = 3'b010; //quantity is 2
									shoppingQuantity = shoppingQuantity + (3'b010 << listedItem*3);
									qFlagNav = 1;
								end
							else if ( (pKEY[2] == 1) && (KEY[2] == 0) )
								begin
									quantity = 3'b011;//quantity is 3
									shoppingQuantity = shoppingQuantity + (3'b011 << listedItem*3);
									qFlagNav = 1;
								end
							else if ( (pKEY[3] == 1) && (KEY[3] == 0) )
								begin
									quantity = 3'b100;//quantity is 4
									shoppingQuantity = shoppingQuantity + (3'b100 << listedItem*3);
									qFlagNav = 1;
								end
							
							if (qFlagNav == 1)//if a quantity is entered execute the following code
								begin
									case(highlight)
										12'b000000000001://if apple is selected
											begin
												shoppingItems = shoppingItems + (4'b0001 << listedItem*4);//store the 4 bit item code in a 24 bit register by bit shifting
												itemPrice[listedItem] = quantity*appleP;//store the price into an array
												t = t + quantity*appleP;//increase the total price by quantity*applePrice
												listedItem = listedItem + 1;//increment the number of selected items
											end
										12'b000000000010://if banana is selected
											begin
												shoppingItems = shoppingItems + (4'b0010 << listedItem*4);
												itemPrice[listedItem] = quantity*bananaP;
												t = t + quantity*bananaP;
												listedItem = listedItem + 1;
											end
										12'b000000000100://if carrot is selected
											begin
												shoppingItems = shoppingItems + (4'b0011 << listedItem*4);
												itemPrice[listedItem] = quantity*carrotP;
												t = t + quantity*carrotP;
												listedItem = listedItem + 1;
											end
										12'b000000001000://if corn is selected
											begin
												shoppingItems = shoppingItems + (4'b0100 << listedItem*4);
												itemPrice[listedItem] = quantity*cornP;
												t = t + quantity*cornP;
												listedItem = listedItem + 1;
											end
										12'b000000010000://if grapes is selected
											begin
												shoppingItems = shoppingItems + (4'b0101 << listedItem*4);
												itemPrice[listedItem] = quantity*grapesP;
												t = t + quantity*grapesP;
												listedItem = listedItem + 1;
											end
										12'b000000100000://if kiwi is selected
											begin
												shoppingItems = shoppingItems + (4'b0110 << listedItem*4);
												itemPrice[listedItem] = quantity*kiwiP;
												t = t + quantity*kiwiP;
												listedItem = listedItem + 1;
											end
										12'b000001000000://if orange is selected						
											begin
												shoppingItems = shoppingItems + (4'b0111 << listedItem*4);
												itemPrice[listedItem] = quantity*orangeP;
												t = t + quantity*orangeP;
												listedItem = listedItem + 1;
											end
										12'b000010000000://if peach is selected
											begin
												shoppingItems = shoppingItems + (4'b1000 << listedItem*4);
												itemPrice[listedItem] = quantity*peachP;
												t = t + quantity*peachP;
												listedItem = listedItem + 1;
											end
										12'b000100000000://if pepper is selected
											begin
												shoppingItems = shoppingItems + (4'b1001 << listedItem*4);
												itemPrice[listedItem] = quantity*pepperP;
												t = t + quantity*pepperP;
												listedItem = listedItem + 1;
											end
										12'b001000000000://if pineapple is selected
											begin
												shoppingItems = shoppingItems + (4'b1010 << listedItem*4);
												itemPrice[listedItem] = quantity*pineappleP;
												t = t + quantity*pineappleP;
												listedItem = listedItem + 1;
											end
										12'b010000000000://if potato is selected
											begin
												shoppingItems = shoppingItems + (4'b1011 << listedItem*4);
												itemPrice[listedItem] = quantity*potatoP;
												t = t + quantity*potatoP;
												listedItem = listedItem + 1;
											end
										12'b100000000000://if tomato is selected
											begin
												shoppingItems = shoppingItems + (4'b1100 << listedItem*4);
												itemPrice[listedItem] = quantity*tomatoP;
												t = t + quantity*tomatoP;
												listedItem = listedItem + 1;
											end
									endcase
								end
						end
				end
					
				2'b10,
				2'b11: begin//Deletion Mode
					//Same logic with Navigation Mode. Navigate through the shopping list with the buutons. Bit shifting is used to change the highlighted items
					if( (pKEY[0] == 1) && (KEY[0] == 0) )
						begin
							if(dhighlight[listedItem-1]==1)
									dhighlight = 6'b000001;
							else
									dhighlight = (dhighlight<<1);
						end
								
					else if( (pKEY[1] == 1) && (KEY[1] == 0) )
						begin
							if(dhighlight[0]==1)
								dhighlight = (dhighlight<<(listedItem-1));
							else
								dhighlight = (dhighlight>>1);
						end
						
					else if( (pKEY[3] == 1) && (KEY[3] == 0) )
						delFlag = 1;
						

					if (delFlag == 1)
					begin
					
						case(dhighlight)
							6'b000001: //delete first item
								begin
								//delete Item
									remainingItemsDown = remainingItemsDown + shoppingItems[23:4];
									shoppingItems = 24'd0;
									shoppingItems = shoppingItems + remainingItemsDown;
					
								//delete Quantity
									remainingQuantityDown = remainingQuantityDown + shoppingQuantity[17:4];
									shoppingQuantity = 18'd0;
									shoppingQuantity = shoppingQuantity + remainingQuantityDown;
							  
								// remove deleted item from Total Cost
									t = t - itemPrice[0];
									
								//delete Price
									for (i=1; i<6; i = i+1)
										begin
											itemPrice[i-1] = itemPrice[i];
										end
									
									itemPrice[5] = 13'd0;
									listedItem = listedItem - 1;
									dhighlight = 6'b000001;
								end
							  
					
							6'b000010: //delete second item
								begin
							  // delete Item
									remainingItemsDown = remainingItemsDown + ( shoppingItems[23:8] << 4 );
									remainingItemsUp = remainingItemsUp + shoppingItems[3:0];
									shoppingItems = 24'd0;
									shoppingItems = remainingItemsDown + remainingItemsUp;
					
							  // delete Quantity
									remainingQuantityDown = remainingQuantityDown + (shoppingQuantity[17:6] << 3);
									remainingQuantityUp = remainingQuantityUp + shoppingQuantity[2:0];
									shoppingQuantity = 18'd0;
									shoppingQuantity = remainingQuantityDown + remainingQuantityUp;
								
								// remove deleted item from Total Cost
									t = t - itemPrice[1];
									
									
							  // delete Price
									for (i=2; i<6; i = i+1)
										begin
											itemPrice[i-1] = itemPrice[i];
										end
									
									itemPrice[5] = 13'd0;
									listedItem = listedItem - 1;
									dhighlight = 6'b000001;
							  
								end
								
							6'b000100: //delete third item
								begin
							  // delete Item
									remainingItemsDown = remainingItemsDown + ( shoppingItems[23:12] << 8 );
									remainingItemsUp = remainingItemsUp + shoppingItems[7:0];
									shoppingItems = 24'd0;
									shoppingItems = remainingItemsDown + remainingItemsUp;
					
							  // delete Quantity
									remainingQuantityDown = remainingQuantityDown + (shoppingQuantity[17:9] << 6);
									remainingQuantityUp = remainingQuantityUp + shoppingQuantity[5:0];
									shoppingQuantity = 18'd0;
									shoppingQuantity = remainingQuantityDown + remainingQuantityUp;
								
								// remove deleted item from Total Cost
									t = t - itemPrice[2];
									
									
							  // delete Price
									for (i=3; i<6; i = i+1)
										begin
											itemPrice[i-1] = itemPrice[i];
										end
									
								
									itemPrice[5] = 13'd0;
									listedItem = listedItem - 1;
									dhighlight = 6'b000001;
							  
								end
							
							6'b001000: //delete fourth item
								begin
							  // delete Item
									remainingItemsDown = remainingItemsDown + ( shoppingItems[23:16] << 12 );
									remainingItemsUp = remainingItemsUp + shoppingItems[11:0];
									shoppingItems = 24'd0;
									shoppingItems = remainingItemsDown + remainingItemsUp;
					
							  // delete Quantity
									remainingQuantityDown = remainingQuantityDown + (shoppingQuantity[17:12] << 9);
									remainingQuantityUp = remainingQuantityUp + shoppingQuantity[8:0];
									shoppingQuantity = 18'd0;
									shoppingQuantity = remainingQuantityDown + remainingQuantityUp;
								
								// remove deleted item from Total Cost
									t = t - itemPrice[3];
									
									
							  // delete Price
									for (i=4; i<6; i = i+1)
										begin
											itemPrice[i-1] = itemPrice[i];
										end
									
								 
									itemPrice[5] = 13'd0;
									listedItem = listedItem - 1;
									dhighlight = 6'b000001;
							  
								end
								
							6'b010000: //delete fifth item
								begin
							  // delete Item
									remainingItemsDown = remainingItemsDown + ( shoppingItems[23:20] << 16 );
									remainingItemsUp = remainingItemsUp + shoppingItems[15:0];
									shoppingItems = 24'd0;
									shoppingItems = remainingItemsDown + remainingItemsUp;
					
							  // delete Quantity
									remainingQuantityDown = remainingQuantityDown + (shoppingQuantity[17:15] << 12);
									remainingQuantityUp = remainingQuantityUp + shoppingQuantity[11:0];
									shoppingQuantity = 18'd0;
									shoppingQuantity = remainingQuantityDown + remainingQuantityUp;
								
								// remove deleted item from Total Cost
									t = t - itemPrice[4];
									
									
							  // delete Price
									for (i=5; i<6; i = i+1)
										begin
											itemPrice[i-1] = itemPrice[i];
										end
									
									itemPrice[5] = 13'd0;
									listedItem = listedItem - 1;
									dhighlight = 6'b000001;
							  
								end
							
							6'b100000: //delete sixth item
								begin
							  // delete Item
									remainingItemsUp = remainingItemsUp + shoppingItems[19:0];
									shoppingItems = 24'd0;
									shoppingItems = shoppingItems + remainingItemsUp;
					
							  // delete Quantity
									remainingQuantityUp = remainingQuantityUp + shoppingQuantity[14:0];
									shoppingQuantity = 18'd0;
									shoppingQuantity = shoppingQuantity + remainingQuantityUp;
								
								// remove deleted item from Total Cost
									t = t - itemPrice[5];
									
									
							  // delete Price
									itemPrice[5] = 13'd0;
									
									
									listedItem = listedItem - 1;
									dhighlight = 6'b000001;
							  
								end
								

						endcase
					end
				end
				
			endcase
			
			for (i=0; i<6; i = i+1)
				begin
						//Determine the digits to be displayed for Price column in the shooping list and store them
						a[i] = itemPrice[i]/10'd1000;
						b[i] = (itemPrice[i]-a[i]*10'd1000)/7'd100;
						c[i] = (itemPrice[i]-a[i]*10'd1000-b[i]*7'd100)/4'd10;
						d[i] = (itemPrice[i]-a[i]*10'd1000-b[i]*7'd100-c[i]*4'd10);
				end
			
			//Determine the digits to be displayed for "Total" in the shooping list and store them
			tFinal[0] = t/14'd10000;
			tFinal[1] = (t-tFinal[0]*14'd10000)/10'd1000;
			tFinal[2] = (t-tFinal[0]*14'd10000-tFinal[1]*10'd1000)/7'd100;
			tFinal[3] = (t-tFinal[0]*14'd10000-tFinal[1]*10'd1000-tFinal[2]*7'd100)/4'd10;
			tFinal[4] = (t-tFinal[0]*14'd10000-tFinal[1]*10'd1000-tFinal[2]*7'd100-tFinal[3]*4'd10);
			
			pSW = SW;//Assign the current values of the switches and the keys to the previous value registers
			pKEY = KEY;
			qFlag = 0;//Set flags to 0
			qFlagNav = 0;
			delFlag = 0;
			remainingItemsUp = 24'd0;//Reset the registers
			remainingItemsDown = 24'd0;
			remainingQuantityUp = 18'd0;
			remainingQuantityDown = 18'd0;
		
		end
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Code for displaying the images to the VGA display
	
	always @ (posedge clk50) 
		begin

			//////////////////////////////////////////////////////////////////////GROCERIES
			if(counter_x>=371 && counter_x<631
			&& counter_y>=75 && counter_y<110)
				color <= groceries_data[{(counter_x-371)*35+counter_y-75}];
			//////////////////////////////////////////////////////////////////////GROUP LOGO
			else if(counter_x>=707 && counter_x<750
			&& counter_y>=50 && counter_y<132)
				color <= groupLogo_data[{(counter_x-707)*82+counter_y-50}];
			//////////////////////////////////////////////////////////////////////ITEM
			else if(counter_x>=160 && counter_x<298
			&& counter_y>=131 && counter_y<144)
				color <= item_data[{(counter_x-160)*13+counter_y-131}];
			//////////////////////////////////////////////////////////////////////SHOPPING LIST
			else if(counter_x>=146 && counter_x<296
			&& counter_y>=52 && counter_y<107)
				color <= shoppingList_data[{(counter_x-146)*55+counter_y-52}];
			//////////////////////////////////////////////////////////////////////TOTAL
			else if(counter_x>=184 && counter_x<259
			&& counter_y>=407 && counter_y<424)
				color <= total_data[{(counter_x-184)*17+counter_y-407}];
			//////////////////////////////////////////////////////////////////////BLACK LINE
			else if(counter_x>=300 && counter_x<305
			&& counter_y>=36 && counter_y<516)
				color<= 8'b00000000;
			//////////////////////////////////////////////////////////////////////BLACK LINE
			else if(counter_x>=305 && counter_x<785
			&& counter_y>=150 && counter_y<155)
				color<= 8'b00000000;
			//////////////////////////////////////////////////////////////////////BLACK LINE
			else if(counter_x>=145 && counter_x<300
			&& counter_y>=151 && counter_y<154)
				color<= 8'b00000000;
			//////////////////////////////////////////////////////////////////////BLACK LINE
			else if(counter_x>=145 && counter_x<300
			&& counter_y>=120 && counter_y<123)
				color<= 8'b00000000;
			//////////////////////////////////////////////////////////////////////BLACK LINE
			else if(counter_x>=145 && counter_x<300
			&& counter_y>=400 && counter_y<403)
				color<= 8'b00000000;
			//////////////////////////////////////////////////////////////////////BLACK LINE
			else if(counter_x>=145 && counter_x<300
			&& counter_y>=425 && counter_y<428)
				color<= 8'b00000000;
			//////////////////////////////////////////////////////////////////////APPLE IMAGE
			else if (counter_x>=330 && counter_x<330+food1XY
			&& counter_y>=170 && counter_y<170+food1XY)
				color <= apple_data[{(counter_x-330)*food1XY+counter_y-170}];
			
			else if (counter_x>=330 && counter_x<330+food1XY
			&& counter_y>=170+food1XY && counter_y<175+food1XY)
				color <= (8'b11111111 << 3*highlight[0]);//highlight the item if it's corresponding bit in highlight register is 1, print white otherwise
				
			else if (counter_x>=343 && counter_x<343+foodPriceX
			&& counter_y>=258 && counter_y<258+foodPriceY)
				color <= appleP_data[{(counter_x-343)*foodPriceY+counter_y-258}];
			/////////////////////////////////////////////////////////////////////GRAPES
			else if (counter_x>=330 && counter_x<330+food1XY
			&& counter_y>=285 && counter_y<285+food1XY)
				color <= grapes_data[{(counter_x-330)*food1XY+counter_y-285}];
			
			else if (counter_x>=330 && counter_x<330+food1XY
			&& counter_y>=285+food1XY && counter_y<290+food1XY)
				color <= (8'b11111111 << 3*highlight[4]);
				
			else if (counter_x>=343 && counter_x<343+foodPriceX
			&& counter_y>=373 && counter_y<373+foodPriceY)
				color <= grapesP_data[{(counter_x-343)*foodPriceY+counter_y-373}];
			
			/////////////////////////////////////////////////////////////////////PEPPER IMAGE
			else if (counter_x>=330 && counter_x<330+food1XY
			&& counter_y>=400 && counter_y<400+food1XY)
				color <= pepper_data[{(counter_x-330)*food1XY+counter_y-400}];
			
			else if (counter_x>=330 && counter_x<330+food1XY
			&& counter_y>=400+food1XY && counter_y<405+food1XY)
				color <= (8'b11111111 << 3*highlight[8]);
				
			else if (counter_x>=343 && counter_x<343+foodPriceX
			&& counter_y>=488 && counter_y<488+foodPriceY)
				color <= pepperP_data[{(counter_x-343)*foodPriceY+counter_y-488}];
			
			/////////////////////////////////////////////////////////////////////BANANA IMAGE
			else if (counter_x>=446 && counter_x<446+food1XY
			&& counter_y>=170 && counter_y<170+food1XY)
				color <= banana_data[{(counter_x-446)*food1XY+counter_y-170}];
			
			else if (counter_x>=446 && counter_x<446+food1XY
			&& counter_y>=170+food1XY && counter_y<175+food1XY)
				color <= (8'b11111111 << 3*highlight[1]);
				
			else if (counter_x>=459 && counter_x<459+foodPriceX
			&& counter_y>=258 && counter_y<258+foodPriceY)
				color <= bananaP_data[{(counter_x-459)*foodPriceY+counter_y-258}];
				
			/////////////////////////////////////////////////////////////////////KIWI IMAGE
			else if (counter_x>=446 && counter_x<446+food1XY
			&& counter_y>=285 && counter_y<285+food1XY)
				color <= kiwi_data[{(counter_x-446)*food1XY+counter_y-285}];
			
			else if (counter_x>=446 && counter_x<446+food1XY
			&& counter_y>=285+food1XY && counter_y<290+food1XY)
				color <= (8'b11111111 << 3*highlight[5]);
				
			else if (counter_x>=459 && counter_x<459+foodPriceX
			&& counter_y>=373 && counter_y<373+foodPriceY)
				color <= kiwiP_data[{(counter_x-459)*foodPriceY+counter_y-373}];
				
			/////////////////////////////////////////////////////////////////////PINEAPPLE IMAGE
			else if (counter_x>=446 && counter_x<446+food1XY
			&& counter_y>=400 && counter_y<400+food1XY)
				color <= pineapple_data[{(counter_x-446)*food1XY+counter_y-400}];
			
			else if (counter_x>=446 && counter_x<446+food1XY
			&& counter_y>=400+food1XY && counter_y<405+food1XY)
				color <= (8'b11111111 << 3*highlight[9]);
				
			else if (counter_x>=459 && counter_x<459+foodPriceX
			&& counter_y>=488 && counter_y<488+foodPriceY)
				color <= pineappleP_data[{(counter_x-459)*foodPriceY+counter_y-488}];
				
			/////////////////////////////////////////////////////////////////////CARROT IMAGE	
			else if (counter_x>=562 && counter_x<562+food1XY
			&& counter_y>=170 && counter_y<170+food1XY)
				color <= carrot_data[{(counter_x-562)*food1XY+counter_y-170}];
			
			else if (counter_x>=562 && counter_x<562+food1XY
			&& counter_y>=170+food1XY && counter_y<175+food1XY)
				color <= (8'b11111111 << 3*highlight[2]);
				
			else if (counter_x>=575 && counter_x<575+foodPriceX
			&& counter_y>=258 && counter_y<258+foodPriceY)
				color <= carrotP_data[{(counter_x-575)*foodPriceY+counter_y-258}];
				
			/////////////////////////////////////////////////////////////////////ORANGE IMAGE
			else if (counter_x>=562 && counter_x<562+food1XY
			&& counter_y>=285 && counter_y<285+food1XY)
				color <= orange_data[{(counter_x-562)*food1XY+counter_y-285}];
			
			else if (counter_x>=562 && counter_x<562+food1XY
			&& counter_y>=285+food1XY && counter_y<290+food1XY)
				color <= (8'b11111111 << 3*highlight[6]);
				
			else if (counter_x>=575 && counter_x<575+foodPriceX
			&& counter_y>=373 && counter_y<373+foodPriceY)
				color <= orangeP_data[{(counter_x-575)*foodPriceY+counter_y-373}];
				
			/////////////////////////////////////////////////////////////////////POTATO IMAGE	
			else if (counter_x>=562 && counter_x<562+food1XY
			&& counter_y>=400 && counter_y<400+food1XY)
				color <= potato_data[{(counter_x-562)*food1XY+counter_y-400}];
			
			else if (counter_x>=562 && counter_x<562+food1XY
			&& counter_y>=400+food1XY && counter_y<405+food1XY)
				color <= (8'b11111111 << 3*highlight[10]);
				
			else if (counter_x>=575 && counter_x<575+foodPriceX
			&& counter_y>=488 && counter_y<488+foodPriceY)
				color <= potatoP_data[{(counter_x-575)*foodPriceY+counter_y-488}];
				
			/////////////////////////////////////////////////////////////////////CORN IMAGE	
			else if (counter_x>=678 && counter_x<678+food1XY
			&& counter_y>=170 && counter_y<170+food1XY)
				color <= corn_data[{(counter_x-678)*food1XY+counter_y-170}];
			
			else if (counter_x>=678 && counter_x<678+food1XY
			&& counter_y>=170+food1XY && counter_y<175+food1XY)
				color <= (8'b11111111 << 3*highlight[3]);
				
			else if (counter_x>=691 && counter_x<691+foodPriceX
			&& counter_y>=258 && counter_y<258+foodPriceY)
				color <= cornP_data[{(counter_x-691)*foodPriceY+counter_y-258}];
				
			/////////////////////////////////////////////////////////////////////PEACH IMAGE
			else if (counter_x>=678 && counter_x<678+food1XY
			&& counter_y>=285 && counter_y<285+food1XY)
				color <= peach_data[{(counter_x-678)*food1XY+counter_y-285}];
			
			else if (counter_x>=678 && counter_x<678+food1XY
			&& counter_y>=285+food1XY && counter_y<290+food1XY)
				color <= (8'b11111111 << 3*highlight[7]);
				
			else if (counter_x>=691 && counter_x<691+foodPriceX
			&& counter_y>=373 && counter_y<373+foodPriceY)
				color <= peachP_data[{(counter_x-691)*foodPriceY+counter_y-373}];
				
			/////////////////////////////////////////////////////////////////////TOMATO IMAGE	
			else if (counter_x>=678 && counter_x<678+food1XY
			&& counter_y>=400 && counter_y<400+food1XY)
				color <= tomato_data[{(counter_x-678)*food1XY+counter_y-400}];
			
			else if (counter_x>=678 && counter_x<678+food1XY
			&& counter_y>=400+food1XY && counter_y<405+food1XY)
				color <= (8'b11111111 << 3*highlight[11]);
			
			else if (counter_x>=691 && counter_x<691+foodPriceX
			&& counter_y>=488 && counter_y<488+foodPriceY)
				color <= tomatoP_data[{(counter_x-691)*foodPriceY+counter_y-488}];
				
			//Print the names of the purchased items
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=170 && counter_y<183 && listedItem>0)
				begin
					if (shoppingItems[3:0] == 4'd1)
						color <= appleShop[{(counter_x-146)*13+counter_y-170}];
					else if (shoppingItems[3:0] == 4'd2)
						color <= bananaShop[{(counter_x-146)*13+counter_y-170}];	
					else if (shoppingItems[3:0] == 4'd3)
						color <= carrotShop[{(counter_x-146)*13+counter_y-170}];
					else if (shoppingItems[3:0] == 4'd4)
						color <= cornShop[{(counter_x-146)*13+counter_y-170}];
					else if (shoppingItems[3:0] == 4'd5)
						color <= grapesShop[{(counter_x-146)*13+counter_y-170}];
					else if (shoppingItems[3:0] == 4'd6)
						color <= kiwiShop[{(counter_x-146)*13+counter_y-170}];
					else if (shoppingItems[3:0] == 4'd7)
						color <= orangeShop[{(counter_x-146)*13+counter_y-170}];
					else if (shoppingItems[3:0] == 4'd8)
						color <= peachShop[{(counter_x-146)*13+counter_y-170}];
					else if (shoppingItems[3:0] == 4'd9)
						color <= pepperShop[{(counter_x-146)*13+counter_y-170}];
					else if (shoppingItems[3:0] == 4'd10)
						color <= pineappleShop[{(counter_x-146)*13+counter_y-170}];
					else if (shoppingItems[3:0] == 4'd11)
						color <= potatoShop[{(counter_x-146)*13+counter_y-170}];
					else if (shoppingItems[3:0] == 4'd12)
						color <= tomatoShop[{(counter_x-146)*13+counter_y-170}];
				end
			//In the deletion mode highlight the item in the shopping list if the corresponding bit is 1
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=183 && counter_y<188 && listedItem>0 && dhighlight[0])
				color<=3'b111;
			
			//Print the purchased quantity of the corresponding item
			else if (counter_x>=230 && counter_x<240
			&& counter_y>=166 && counter_y<186 && listedItem>0)
				begin
					if (shoppingQuantity[2:0] == 3'b001)
						color <= one[{(counter_x-230)*20+counter_y-166}];
					else if (shoppingQuantity[2:0] == 3'b010)
						color <= two[{(counter_x-230)*20+counter_y-166}];
					else if (shoppingQuantity[2:0] == 3'b011)
						color <= three[{(counter_x-230)*20+counter_y-166}];
					else if (shoppingQuantity[2:0] == 3'b100)
						color <= four[{(counter_x-230)*20+counter_y-166}];
				end
			
			//Print first digit of the price
			else if (counter_x>=250 && counter_x<260
			&& counter_y>=166 && counter_y<186 && listedItem>0)
				begin
					if (a[0] == 1)
						color <= one[{(counter_x-250)*20+counter_y-166}];
					else if (a[0] == 2)
						color <= two[{(counter_x-250)*20+counter_y-166}];
					else if (a[0] == 3)
						color <= three[{(counter_x-250)*20+counter_y-166}];
					else if (a[0] == 4)
						color <= four[{(counter_x-250)*20+counter_y-166}];
					else if (a[0] == 5)
						color <= five[{(counter_x-250)*20+counter_y-166}];
					else if (a[0] == 6)
						color <= six[{(counter_x-250)*20+counter_y-166}];
					else if (a[0] == 7)
						color <= seven[{(counter_x-250)*20+counter_y-166}];
					else if (a[0] == 8)
						color <= eight[{(counter_x-250)*20+counter_y-166}];
					else if (a[0] == 9)
						color <= nine[{(counter_x-250)*20+counter_y-166}];
					else if (a[0] == 0)
						color <= zero[{(counter_x-250)*20+counter_y-166}];						
				end
			
			//Print second digit of the price
			else if (counter_x>=260 && counter_x<270
			&& counter_y>=166 && counter_y<186 && listedItem>0)
				begin
					if (b[0] == 1)
						color <= one[{(counter_x-260)*20+counter_y-166}];
					else if (b[0] == 2)
						color <= two[{(counter_x-260)*20+counter_y-166}];
					else if (b[0] == 3)
						color <= three[{(counter_x-260)*20+counter_y-166}];
					else if (b[0] == 4)
						color <= four[{(counter_x-260)*20+counter_y-166}];
					else if (b[0] == 5)
						color <= five[{(counter_x-260)*20+counter_y-166}];
					else if (b[0] == 6)
						color <= six[{(counter_x-260)*20+counter_y-166}];
					else if (b[0] == 7)
						color <= seven[{(counter_x-260)*20+counter_y-166}];
					else if (b[0] == 8)
						color <= eight[{(counter_x-260)*20+counter_y-166}];
					else if (b[0] == 9)
						color <= nine[{(counter_x-260)*20+counter_y-166}];
					else if (b[0] == 0)
						color <= zero[{(counter_x-260)*20+counter_y-166}];						
				end
			
			//Print the dot
			else if (counter_x>=270 && counter_x<275
			&& counter_y>=166 && counter_y<186 && listedItem>0)
				color <= dot[{(counter_x-270)*20+counter_y-166}];
				
			//Print third digit of the price	
			else if (counter_x>=275 && counter_x<285
			&& counter_y>=166 && counter_y<186 && listedItem>0)
				begin
					if (c[0] == 1)
						color <= one[{(counter_x-275)*20+counter_y-166}];
					else if (c[0] == 2)
						color <= two[{(counter_x-275)*20+counter_y-166}];
					else if (c[0] == 3)
						color <= three[{(counter_x-275)*20+counter_y-166}];
					else if (c[0] == 4)
						color <= four[{(counter_x-275)*20+counter_y-166}];
					else if (c[0] == 5)
						color <= five[{(counter_x-275)*20+counter_y-166}];
					else if (c[0] == 6)
						color <= six[{(counter_x-275)*20+counter_y-166}];
					else if (c[0] == 7)
						color <= seven[{(counter_x-275)*20+counter_y-166}];
					else if (c[0] == 8)
						color <= eight[{(counter_x-275)*20+counter_y-166}];
					else if (c[0] == 9)
						color <= nine[{(counter_x-275)*20+counter_y-166}];
					else if (c[0] == 0)
						color <= zero[{(counter_x-275)*20+counter_y-166}];						
				end
			
			//Print fourth digit of the price
			else if (counter_x>=285 && counter_x<295
			&& counter_y>=166 && counter_y<186 && listedItem>0)
				begin
					if (d[0] == 1)
						color <= one[{(counter_x-285)*20+counter_y-166}];
					else if (d[0] == 2)
						color <= two[{(counter_x-285)*20+counter_y-166}];
					else if (d[0] == 3)
						color <= three[{(counter_x-285)*20+counter_y-166}];
					else if (d[0] == 4)
						color <= four[{(counter_x-285)*20+counter_y-166}];
					else if (d[0] == 5)
						color <= five[{(counter_x-285)*20+counter_y-166}];
					else if (d[0] == 6)
						color <= six[{(counter_x-285)*20+counter_y-166}];
					else if (d[0] == 7)
						color <= seven[{(counter_x-285)*20+counter_y-166}];
					else if (d[0] == 8)
						color <= eight[{(counter_x-285)*20+counter_y-166}];
					else if (d[0] == 9)
						color <= nine[{(counter_x-285)*20+counter_y-166}];
					else if (d[0] == 0)
						color <= zero[{(counter_x-285)*20+counter_y-166}];						
				end
			
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=200 && counter_y<213 && listedItem>1)
				begin
					if (shoppingItems[7:4] == 4'd1)
						color <= appleShop[{(counter_x-146)*13+counter_y-200}];
					else if (shoppingItems[7:4] == 4'd2)
						color <= bananaShop[{(counter_x-146)*13+counter_y-200}];	
					else if (shoppingItems[7:4] == 4'd3)
						color <= carrotShop[{(counter_x-146)*13+counter_y-200}];
					else if (shoppingItems[7:4] == 4'd4)
						color <= cornShop[{(counter_x-146)*13+counter_y-200}];
					else if (shoppingItems[7:4] == 4'd5)
						color <= grapesShop[{(counter_x-146)*13+counter_y-200}];
					else if (shoppingItems[7:4] == 4'd6)
						color <= kiwiShop[{(counter_x-146)*13+counter_y-200}];
					else if (shoppingItems[7:4] == 4'd7)
						color <= orangeShop[{(counter_x-146)*13+counter_y-200}];
					else if (shoppingItems[7:4] == 4'd8)
						color <= peachShop[{(counter_x-146)*13+counter_y-200}];
					else if (shoppingItems[7:4] == 4'd9)
						color <= pepperShop[{(counter_x-146)*13+counter_y-200}];
					else if (shoppingItems[7:4] == 4'd10)
						color <= pineappleShop[{(counter_x-146)*13+counter_y-200}];
					else if (shoppingItems[7:4] == 4'd11)
						color <= potatoShop[{(counter_x-146)*13+counter_y-200}];
					else if (shoppingItems[7:4] == 4'd12)
						color <= tomatoShop[{(counter_x-146)*13+counter_y-200}];
				end
				
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=213 && counter_y<218 && listedItem>1 && dhighlight[1])
				color<=3'b111;
			
			else if (counter_x>=230 && counter_x<240
			&& counter_y>=196 && counter_y<216 && listedItem>1)
				begin
					if (shoppingQuantity[5:3] == 3'b001)
						color <= one[{(counter_x-230)*20+counter_y-196}];
					else if (shoppingQuantity[5:3] == 3'b010)
						color <= two[{(counter_x-230)*20+counter_y-196}];
					else if (shoppingQuantity[5:3] == 3'b011)
						color <= three[{(counter_x-230)*20+counter_y-196}];
					else if (shoppingQuantity[5:3] == 3'b100)
						color <= four[{(counter_x-230)*20+counter_y-196}];
				end
			
			else if (counter_x>=250 && counter_x<260
			&& counter_y>=196 && counter_y<216 && listedItem>1)
				begin
					if (a[1] == 1)
						color <= one[{(counter_x-250)*20+counter_y-196}];
					else if (a[1] == 2)
						color <= two[{(counter_x-250)*20+counter_y-196}];
					else if (a[1] == 3)
						color <= three[{(counter_x-250)*20+counter_y-196}];
					else if (a[1] == 4)
						color <= four[{(counter_x-250)*20+counter_y-196}];
					else if (a[1] == 5)
						color <= five[{(counter_x-250)*20+counter_y-196}];
					else if (a[1] == 6)
						color <= six[{(counter_x-250)*20+counter_y-196}];
					else if (a[1] == 7)
						color <= seven[{(counter_x-250)*20+counter_y-196}];
					else if (a[1] == 8)
						color <= eight[{(counter_x-250)*20+counter_y-196}];
					else if (a[1] == 9)
						color <= nine[{(counter_x-250)*20+counter_y-196}];
					else if (a[1] == 0)
						color <= zero[{(counter_x-250)*20+counter_y-196}];						
				end
				
			else if (counter_x>=260 && counter_x<270
			&& counter_y>=196 && counter_y<216 && listedItem>1)
				begin
					if (b[1] == 1)
						color <= one[{(counter_x-260)*20+counter_y-196}];
					else if (b[1] == 2)
						color <= two[{(counter_x-260)*20+counter_y-196}];
					else if (b[1] == 3)
						color <= three[{(counter_x-260)*20+counter_y-196}];
					else if (b[1] == 4)
						color <= four[{(counter_x-260)*20+counter_y-196}];
					else if (b[1] == 5)
						color <= five[{(counter_x-260)*20+counter_y-196}];
					else if (b[1] == 6)
						color <= six[{(counter_x-260)*20+counter_y-196}];
					else if (b[1] == 7)
						color <= seven[{(counter_x-260)*20+counter_y-196}];
					else if (b[1] == 8)
						color <= eight[{(counter_x-260)*20+counter_y-196}];
					else if (b[1] == 9)
						color <= nine[{(counter_x-260)*20+counter_y-196}];
					else if (b[1] == 0)
						color <= zero[{(counter_x-260)*20+counter_y-196}];						
				end
				
			else if (counter_x>=270 && counter_x<275
			&& counter_y>=196 && counter_y<216 && listedItem>1)
				color <= dot[{(counter_x-270)*20+counter_y-196}];
				
			else if (counter_x>=275 && counter_x<285
			&& counter_y>=196 && counter_y<216 && listedItem>1)
				begin
					if (c[1] == 1)
						color <= one[{(counter_x-275)*20+counter_y-196}];
					else if (c[1] == 2)
						color <= two[{(counter_x-275)*20+counter_y-196}];
					else if (c[1] == 3)
						color <= three[{(counter_x-275)*20+counter_y-196}];
					else if (c[1] == 4)
						color <= four[{(counter_x-275)*20+counter_y-196}];
					else if (c[1] == 5)
						color <= five[{(counter_x-275)*20+counter_y-196}];
					else if (c[1] == 6)
						color <= six[{(counter_x-275)*20+counter_y-196}];
					else if (c[1] == 7)
						color <= seven[{(counter_x-275)*20+counter_y-196}];
					else if (c[1] == 8)
						color <= eight[{(counter_x-275)*20+counter_y-196}];
					else if (c[1] == 9)
						color <= nine[{(counter_x-275)*20+counter_y-196}];
					else if (c[1] == 0)
						color <= zero[{(counter_x-275)*20+counter_y-196}];						
				end
				
			else if (counter_x>=285 && counter_x<295
			&& counter_y>=196 && counter_y<216 && listedItem>1)
				begin
					if (d[1] == 1)
						color <= one[{(counter_x-285)*20+counter_y-196}];
					else if (d[1] == 2)
						color <= two[{(counter_x-285)*20+counter_y-196}];
					else if (d[1] == 3)
						color <= three[{(counter_x-285)*20+counter_y-196}];
					else if (d[1] == 4)
						color <= four[{(counter_x-285)*20+counter_y-196}];
					else if (d[1] == 5)
						color <= five[{(counter_x-285)*20+counter_y-196}];
					else if (d[1] == 6)
						color <= six[{(counter_x-285)*20+counter_y-196}];
					else if (d[1] == 7)
						color <= seven[{(counter_x-285)*20+counter_y-196}];
					else if (d[1] == 8)
						color <= eight[{(counter_x-285)*20+counter_y-196}];
					else if (d[1] == 9)
						color <= nine[{(counter_x-285)*20+counter_y-196}];
					else if (d[1] == 0)
						color <= zero[{(counter_x-285)*20+counter_y-196}];						
				end
				
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=230 && counter_y<243 && listedItem>2)
				begin
					if (shoppingItems[11:8] == 4'd1)
						color <= appleShop[{(counter_x-146)*13+counter_y-230}];
					else if (shoppingItems[11:8] == 4'd2)
						color <= bananaShop[{(counter_x-146)*13+counter_y-230}];	
					else if (shoppingItems[11:8] == 4'd3)
						color <= carrotShop[{(counter_x-146)*13+counter_y-230}];
					else if (shoppingItems[11:8] == 4'd4)
						color <= cornShop[{(counter_x-146)*13+counter_y-230}];
					else if (shoppingItems[11:8] == 4'd5)
						color <= grapesShop[{(counter_x-146)*13+counter_y-230}];
					else if (shoppingItems[11:8] == 4'd6)
						color <= kiwiShop[{(counter_x-146)*13+counter_y-230}];
					else if (shoppingItems[11:8] == 4'd7)
						color <= orangeShop[{(counter_x-146)*13+counter_y-230}];
					else if (shoppingItems[11:8] == 4'd8)
						color <= peachShop[{(counter_x-146)*13+counter_y-230}];
					else if (shoppingItems[11:8] == 4'd9)
						color <= pepperShop[{(counter_x-146)*13+counter_y-230}];
					else if (shoppingItems[11:8] == 4'd10)
						color <= pineappleShop[{(counter_x-146)*13+counter_y-230}];
					else if (shoppingItems[11:8] == 4'd11)
						color <= potatoShop[{(counter_x-146)*13+counter_y-230}];
					else if (shoppingItems[11:8] == 4'd12)
						color <= tomatoShop[{(counter_x-146)*13+counter_y-230}];
				end
				
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=243 && counter_y<248 && listedItem>2 && dhighlight[2])
				color<=3'b111;

			else if (counter_x>=230 && counter_x<240
			&& counter_y>=226 && counter_y<246 && listedItem>2)
				begin
					if (shoppingQuantity[8:6] == 3'b001)
						color <= one[{(counter_x-230)*20+counter_y-226}];
					else if (shoppingQuantity[8:6] == 3'b010)
						color <= two[{(counter_x-230)*20+counter_y-226}];
					else if (shoppingQuantity[8:6] == 3'b011)
						color <= three[{(counter_x-230)*20+counter_y-226}];
					else if (shoppingQuantity[8:6] == 3'b100)
						color <= four[{(counter_x-230)*20+counter_y-226}];
				end	
			
			else if (counter_x>=250 && counter_x<260
			&& counter_y>=226 && counter_y<246 && listedItem>2)
				begin
					if (a[2] == 1)
						color <= one[{(counter_x-250)*20+counter_y-226}];
					else if (a[2] == 2)
						color <= two[{(counter_x-250)*20+counter_y-226}];
					else if (a[2] == 3)
						color <= three[{(counter_x-250)*20+counter_y-226}];
					else if (a[2] == 4)
						color <= four[{(counter_x-250)*20+counter_y-226}];
					else if (a[2] == 5)
						color <= five[{(counter_x-250)*20+counter_y-226}];
					else if (a[2] == 6)
						color <= six[{(counter_x-250)*20+counter_y-226}];
					else if (a[2] == 7)
						color <= seven[{(counter_x-250)*20+counter_y-226}];
					else if (a[2] == 8)
						color <= eight[{(counter_x-250)*20+counter_y-226}];
					else if (a[2] == 9)
						color <= nine[{(counter_x-250)*20+counter_y-226}];
					else if (a[2] == 0)
						color <= zero[{(counter_x-250)*20+counter_y-226}];						
				end
			else if (counter_x>=260 && counter_x<270
			&& counter_y>=226 && counter_y<246 && listedItem>2)
				begin
					if (b[2] == 1)
						color <= one[{(counter_x-260)*20+counter_y-226}];
					else if (b[2] == 2)
						color <= two[{(counter_x-260)*20+counter_y-226}];
					else if (b[2] == 3)
						color <= three[{(counter_x-260)*20+counter_y-226}];
					else if (b[2] == 4)
						color <= four[{(counter_x-260)*20+counter_y-226}];
					else if (b[2] == 5)
						color <= five[{(counter_x-260)*20+counter_y-226}];
					else if (b[2] == 6)
						color <= six[{(counter_x-260)*20+counter_y-226}];
					else if (b[2] == 7)
						color <= seven[{(counter_x-260)*20+counter_y-226}];
					else if (b[2] == 8)
						color <= eight[{(counter_x-260)*20+counter_y-226}];
					else if (b[2] == 9)
						color <= nine[{(counter_x-260)*20+counter_y-226}];
					else if (b[2] == 0)
						color <= zero[{(counter_x-260)*20+counter_y-226}];						
				end
				
			else if (counter_x>=270 && counter_x<275
			&& counter_y>=226 && counter_y<246 && listedItem>2)
				color <= dot[{(counter_x-270)*20+counter_y-226}];
				
			else if (counter_x>=275 && counter_x<285
			&& counter_y>=226 && counter_y<246 && listedItem>2)
				begin
					if (c[2] == 1)
						color <= one[{(counter_x-275)*20+counter_y-226}];
					else if (c[2] == 2)
						color <= two[{(counter_x-275)*20+counter_y-226}];
					else if (c[2] == 3)
						color <= three[{(counter_x-275)*20+counter_y-226}];
					else if (c[2] == 4)
						color <= four[{(counter_x-275)*20+counter_y-226}];
					else if (c[2] == 5)
						color <= five[{(counter_x-275)*20+counter_y-226}];
					else if (c[2] == 6)
						color <= six[{(counter_x-275)*20+counter_y-226}];
					else if (c[2] == 7)
						color <= seven[{(counter_x-275)*20+counter_y-226}];
					else if (c[2] == 8)
						color <= eight[{(counter_x-275)*20+counter_y-226}];
					else if (c[2] == 9)
						color <= nine[{(counter_x-275)*20+counter_y-226}];
					else if (c[2] == 0)
						color <= zero[{(counter_x-275)*20+counter_y-226}];						
				end
				
			else if (counter_x>=285 && counter_x<295
			&& counter_y>=226 && counter_y<246 && listedItem>2)
				begin
					if (d[2] == 1)
						color <= one[{(counter_x-285)*20+counter_y-226}];
					else if (d[2] == 2)
						color <= two[{(counter_x-285)*20+counter_y-226}];
					else if (d[2] == 3)
						color <= three[{(counter_x-285)*20+counter_y-226}];
					else if (d[2] == 4)
						color <= four[{(counter_x-285)*20+counter_y-226}];
					else if (d[2] == 5)
						color <= five[{(counter_x-285)*20+counter_y-226}];
					else if (d[2] == 6)
						color <= six[{(counter_x-285)*20+counter_y-226}];
					else if (d[2] == 7)
						color <= seven[{(counter_x-285)*20+counter_y-226}];
					else if (d[2] == 8)
						color <= eight[{(counter_x-285)*20+counter_y-226}];
					else if (d[2] == 9)
						color <= nine[{(counter_x-285)*20+counter_y-226}];
					else if (d[2] == 0)
						color <= zero[{(counter_x-285)*20+counter_y-226}];						
				end
				
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=260 && counter_y<273 && listedItem>3)
				begin
					if (shoppingItems[15:12] == 4'd1)
						color <= appleShop[{(counter_x-146)*13+counter_y-260}];
					else if (shoppingItems[15:12] == 4'd2)
						color <= bananaShop[{(counter_x-146)*13+counter_y-260}];	
					else if (shoppingItems[15:12] == 4'd3)
						color <= carrotShop[{(counter_x-146)*13+counter_y-260}];
					else if (shoppingItems[15:12] == 4'd4)
						color <= cornShop[{(counter_x-146)*13+counter_y-260}];
					else if (shoppingItems[15:12] == 4'd5)
						color <= grapesShop[{(counter_x-146)*13+counter_y-260}];
					else if (shoppingItems[15:12] == 4'd6)
						color <= kiwiShop[{(counter_x-146)*13+counter_y-260}];
					else if (shoppingItems[15:12] == 4'd7)
						color <= orangeShop[{(counter_x-146)*13+counter_y-260}];
					else if (shoppingItems[15:12] == 4'd8)
						color <= peachShop[{(counter_x-146)*13+counter_y-260}];
					else if (shoppingItems[15:12] == 4'd9)
						color <= pepperShop[{(counter_x-146)*13+counter_y-260}];
					else if (shoppingItems[15:12] == 4'd10)
						color <= pineappleShop[{(counter_x-146)*13+counter_y-260}];
					else if (shoppingItems[15:12] == 4'd11)
						color <= potatoShop[{(counter_x-146)*13+counter_y-260}];
					else if (shoppingItems[15:12] == 4'd12)
						color <= tomatoShop[{(counter_x-146)*13+counter_y-260}];
				end
				
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=273 && counter_y<278 && listedItem>3 && dhighlight[3])
				color<=3'b111;

			else if (counter_x>=230 && counter_x<240
			&& counter_y>=256 && counter_y<276 && listedItem>3)
				begin
					if (shoppingQuantity[11:9] == 3'b001)
						color <= one[{(counter_x-230)*20+counter_y-256}];
					else if (shoppingQuantity[11:9] == 3'b010)
						color <= two[{(counter_x-230)*20+counter_y-256}];
					else if (shoppingQuantity[11:9] == 3'b011)
						color <= three[{(counter_x-230)*20+counter_y-256}];
					else if (shoppingQuantity[11:9] == 3'b100)
						color <= four[{(counter_x-230)*20+counter_y-256}];
				end
				
			else if (counter_x>=250 && counter_x<260
			&& counter_y>=256 && counter_y<276 && listedItem>3)
				begin
					if (a[3] == 1)
						color <= one[{(counter_x-250)*20+counter_y-256}];
					else if (a[3] == 2)
						color <= two[{(counter_x-250)*20+counter_y-256}];
					else if (a[3] == 3)
						color <= three[{(counter_x-250)*20+counter_y-256}];
					else if (a[3] == 4)
						color <= four[{(counter_x-250)*20+counter_y-256}];
					else if (a[3] == 5)
						color <= five[{(counter_x-250)*20+counter_y-256}];
					else if (a[3] == 6)
						color <= six[{(counter_x-250)*20+counter_y-256}];
					else if (a[3] == 7)
						color <= seven[{(counter_x-250)*20+counter_y-256}];
					else if (a[3] == 8)
						color <= eight[{(counter_x-250)*20+counter_y-256}];
					else if (a[3] == 9)
						color <= nine[{(counter_x-250)*20+counter_y-256}];
					else if (a[3] == 0)
						color <= zero[{(counter_x-250)*20+counter_y-256}];						
				end
			else if (counter_x>=260 && counter_x<270
			&& counter_y>=256 && counter_y<276 && listedItem>3)
				begin
					if (b[3] == 1)
						color <= one[{(counter_x-260)*20+counter_y-256}];
					else if (b[3] == 2)
						color <= two[{(counter_x-260)*20+counter_y-256}];
					else if (b[3] == 3)
						color <= three[{(counter_x-260)*20+counter_y-256}];
					else if (b[3] == 4)
						color <= four[{(counter_x-260)*20+counter_y-256}];
					else if (b[3] == 5)
						color <= five[{(counter_x-260)*20+counter_y-256}];
					else if (b[3] == 6)
						color <= six[{(counter_x-260)*20+counter_y-256}];
					else if (b[3] == 7)
						color <= seven[{(counter_x-260)*20+counter_y-256}];
					else if (b[3] == 8)
						color <= eight[{(counter_x-260)*20+counter_y-256}];
					else if (b[3] == 9)
						color <= nine[{(counter_x-260)*20+counter_y-256}];
					else if (b[3] == 0)
						color <= zero[{(counter_x-260)*20+counter_y-256}];						
				end
				
			else if (counter_x>=270 && counter_x<275
			&& counter_y>=256 && counter_y<276 && listedItem>3)
				color <= dot[{(counter_x-270)*20+counter_y-256}];
				
			else if (counter_x>=275 && counter_x<285
			&& counter_y>=256 && counter_y<276 && listedItem>3)
				begin
					if (c[3] == 1)
						color <= one[{(counter_x-275)*20+counter_y-256}];
					else if (c[3] == 2)
						color <= two[{(counter_x-275)*20+counter_y-256}];
					else if (c[3] == 3)
						color <= three[{(counter_x-275)*20+counter_y-256}];
					else if (c[3] == 4)
						color <= four[{(counter_x-275)*20+counter_y-256}];
					else if (c[3] == 5)
						color <= five[{(counter_x-275)*20+counter_y-256}];
					else if (c[3] == 6)
						color <= six[{(counter_x-275)*20+counter_y-256}];
					else if (c[3] == 7)
						color <= seven[{(counter_x-275)*20+counter_y-256}];
					else if (c[3] == 8)
						color <= eight[{(counter_x-275)*20+counter_y-256}];
					else if (c[3] == 9)
						color <= nine[{(counter_x-275)*20+counter_y-256}];
					else if (c[3] == 0)
						color <= zero[{(counter_x-275)*20+counter_y-256}];						
				end
				
			else if (counter_x>=285 && counter_x<295
			&& counter_y>=256 && counter_y<276 && listedItem>3)
				begin
					if (d[3] == 1)
						color <= one[{(counter_x-285)*20+counter_y-256}];
					else if (d[3] == 2)
						color <= two[{(counter_x-285)*20+counter_y-256}];
					else if (d[3] == 3)
						color <= three[{(counter_x-285)*20+counter_y-256}];
					else if (d[3] == 4)
						color <= four[{(counter_x-285)*20+counter_y-256}];
					else if (d[3] == 5)
						color <= five[{(counter_x-285)*20+counter_y-256}];
					else if (d[3] == 6)
						color <= six[{(counter_x-285)*20+counter_y-256}];
					else if (d[3] == 7)
						color <= seven[{(counter_x-285)*20+counter_y-256}];
					else if (d[3] == 8)
						color <= eight[{(counter_x-285)*20+counter_y-256}];
					else if (d[3] == 9)
						color <= nine[{(counter_x-285)*20+counter_y-256}];
					else if (d[3] == 0)
						color <= zero[{(counter_x-285)*20+counter_y-256}];						
				end
				
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=290 && counter_y<303 && listedItem>4)
				begin
					if (shoppingItems[19:16] == 4'd1)
						color <= appleShop[{(counter_x-146)*13+counter_y-290}];
					else if (shoppingItems[19:16] == 4'd2)
						color <= bananaShop[{(counter_x-146)*13+counter_y-290}];	
					else if (shoppingItems[19:16] == 4'd3)
						color <= carrotShop[{(counter_x-146)*13+counter_y-290}];
					else if (shoppingItems[19:16] == 4'd4)
						color <= cornShop[{(counter_x-146)*13+counter_y-290}];
					else if (shoppingItems[19:16] == 4'd5)
						color <= grapesShop[{(counter_x-146)*13+counter_y-290}];
					else if (shoppingItems[19:16] == 4'd6)
						color <= kiwiShop[{(counter_x-146)*13+counter_y-290}];
					else if (shoppingItems[19:16] == 4'd7)
						color <= orangeShop[{(counter_x-146)*13+counter_y-290}];
					else if (shoppingItems[19:16] == 4'd8)
						color <= peachShop[{(counter_x-146)*13+counter_y-290}];
					else if (shoppingItems[19:16] == 4'd9)
						color <= pepperShop[{(counter_x-146)*13+counter_y-290}];
					else if (shoppingItems[19:16] == 4'd10)
						color <= pineappleShop[{(counter_x-146)*13+counter_y-290}];
					else if (shoppingItems[19:16] == 4'd11)
						color <= potatoShop[{(counter_x-146)*13+counter_y-290}];
					else if (shoppingItems[19:16] == 4'd12)
						color <= tomatoShop[{(counter_x-146)*13+counter_y-290}];
				end
				
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=303 && counter_y<308 && listedItem>4 && dhighlight[4])
				color<=3'b111;
			
			else if (counter_x>=230 && counter_x<240
			&& counter_y>=286 && counter_y<306 && listedItem>4)
				begin
					if (shoppingQuantity[14:12] == 3'b001)
						color <= one[{(counter_x-230)*20+counter_y-286}];
					else if (shoppingQuantity[14:12] == 3'b010)
						color <= two[{(counter_x-230)*20+counter_y-286}];
					else if (shoppingQuantity[14:12] == 3'b011)
						color <= three[{(counter_x-230)*20+counter_y-286}];
					else if (shoppingQuantity[14:12] == 3'b100)
						color <= four[{(counter_x-230)*20+counter_y-286}];
				end
				
			else if (counter_x>=250 && counter_x<260
			&& counter_y>=286 && counter_y<306 && listedItem>4)
				begin
					if (a[4] == 1)
						color <= one[{(counter_x-250)*20+counter_y-286}];
					else if (a[4] == 2)
						color <= two[{(counter_x-250)*20+counter_y-286}];
					else if (a[4] == 3)
						color <= three[{(counter_x-250)*20+counter_y-286}];
					else if (a[4] == 4)
						color <= four[{(counter_x-250)*20+counter_y-286}];
					else if (a[4] == 5)
						color <= five[{(counter_x-250)*20+counter_y-286}];
					else if (a[4] == 6)
						color <= six[{(counter_x-250)*20+counter_y-286}];
					else if (a[4] == 7)
						color <= seven[{(counter_x-250)*20+counter_y-286}];
					else if (a[4] == 8)
						color <= eight[{(counter_x-250)*20+counter_y-286}];
					else if (a[4] == 9)
						color <= nine[{(counter_x-250)*20+counter_y-286}];
					else if (a[4] == 0)
						color <= zero[{(counter_x-250)*20+counter_y-286}];						
				end
			else if (counter_x>=260 && counter_x<270
			&& counter_y>=286 && counter_y<306 && listedItem>4)
				begin
					if (b[4] == 1)
						color <= one[{(counter_x-260)*20+counter_y-286}];
					else if (b[4] == 2)
						color <= two[{(counter_x-260)*20+counter_y-286}];
					else if (b[4] == 3)
						color <= three[{(counter_x-260)*20+counter_y-286}];
					else if (b[4] == 4)
						color <= four[{(counter_x-260)*20+counter_y-286}];
					else if (b[4] == 5)
						color <= five[{(counter_x-260)*20+counter_y-286}];
					else if (b[4] == 6)
						color <= six[{(counter_x-260)*20+counter_y-286}];
					else if (b[4] == 7)
						color <= seven[{(counter_x-260)*20+counter_y-286}];
					else if (b[4] == 8)
						color <= eight[{(counter_x-260)*20+counter_y-286}];
					else if (b[4] == 9)
						color <= nine[{(counter_x-260)*20+counter_y-286}];
					else if (b[4] == 0)
						color <= zero[{(counter_x-260)*20+counter_y-286}];						
				end
				
			else if (counter_x>=270 && counter_x<275
			&& counter_y>=286 && counter_y<306 && listedItem>4)
				color <= dot[{(counter_x-270)*20+counter_y-286}];
				
			else if (counter_x>=275 && counter_x<285
			&& counter_y>=286 && counter_y<306 && listedItem>4)
				begin
					if (c[4] == 1)
						color <= one[{(counter_x-275)*20+counter_y-286}];
					else if (c[4] == 2)
						color <= two[{(counter_x-275)*20+counter_y-286}];
					else if (c[4] == 3)
						color <= three[{(counter_x-275)*20+counter_y-286}];
					else if (c[4] == 4)
						color <= four[{(counter_x-275)*20+counter_y-286}];
					else if (c[4] == 5)
						color <= five[{(counter_x-275)*20+counter_y-286}];
					else if (c[4] == 6)
						color <= six[{(counter_x-275)*20+counter_y-286}];
					else if (c[4] == 7)
						color <= seven[{(counter_x-275)*20+counter_y-286}];
					else if (c[4] == 8)
						color <= eight[{(counter_x-275)*20+counter_y-286}];
					else if (c[4] == 9)
						color <= nine[{(counter_x-275)*20+counter_y-286}];
					else if (c[4] == 0)
						color <= zero[{(counter_x-275)*20+counter_y-286}];						
				end
				
			else if (counter_x>=285 && counter_x<295
			&& counter_y>=286 && counter_y<306 && listedItem>4)
				begin
					if (d[4] == 1)
						color <= one[{(counter_x-285)*20+counter_y-286}];
					else if (d[4] == 2)
						color <= two[{(counter_x-285)*20+counter_y-286}];
					else if (d[4] == 3)
						color <= three[{(counter_x-285)*20+counter_y-286}];
					else if (d[4] == 4)
						color <= four[{(counter_x-285)*20+counter_y-286}];
					else if (d[4] == 5)
						color <= five[{(counter_x-285)*20+counter_y-286}];
					else if (d[4] == 6)
						color <= six[{(counter_x-285)*20+counter_y-286}];
					else if (d[4] == 7)
						color <= seven[{(counter_x-285)*20+counter_y-286}];
					else if (d[4] == 8)
						color <= eight[{(counter_x-285)*20+counter_y-286}];
					else if (d[4] == 9)
						color <= nine[{(counter_x-285)*20+counter_y-286}];
					else if (d[4] == 0)
						color <= zero[{(counter_x-285)*20+counter_y-286}];						
				end
				
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=320 && counter_y<333 && listedItem>5)
				begin
					if (shoppingItems[23:20] == 4'd1)
						color <= appleShop[{(counter_x-146)*13+counter_y-320}];
					else if (shoppingItems[23:20] == 4'd2)
						color <= bananaShop[{(counter_x-146)*13+counter_y-320}];	
					else if (shoppingItems[23:20] == 4'd3)
						color <= carrotShop[{(counter_x-146)*13+counter_y-320}];
					else if (shoppingItems[23:20] == 4'd4)
						color <= cornShop[{(counter_x-146)*13+counter_y-320}];
					else if (shoppingItems[23:20] == 4'd5)
						color <= grapesShop[{(counter_x-146)*13+counter_y-320}];
					else if (shoppingItems[23:20] == 4'd6)
						color <= kiwiShop[{(counter_x-146)*13+counter_y-320}];
					else if (shoppingItems[23:20] == 4'd7)
						color <= orangeShop[{(counter_x-146)*13+counter_y-320}];
					else if (shoppingItems[23:20] == 4'd8)
						color <= peachShop[{(counter_x-146)*13+counter_y-320}];
					else if (shoppingItems[23:20] == 4'd9)
						color <= pepperShop[{(counter_x-146)*13+counter_y-320}];
					else if (shoppingItems[23:20] == 4'd10)
						color <= pineappleShop[{(counter_x-146)*13+counter_y-320}];
					else if (shoppingItems[23:20] == 4'd11)
						color <= potatoShop[{(counter_x-146)*13+counter_y-320}];
					else if (shoppingItems[23:20] == 4'd12)
						color <= tomatoShop[{(counter_x-146)*13+counter_y-320}];
				end
			
			else if (counter_x>=146 && counter_x<227
			&& counter_y>=333 && counter_y<338 && listedItem>5 && dhighlight[5])
				color<=3'b111;

			else if (counter_x>=230 && counter_x<240
			&& counter_y>=316 && counter_y<336 && listedItem>5)
				begin
					if (shoppingQuantity[17:15] == 3'b001)
						color <= one[{(counter_x-230)*20+counter_y-316}];
					else if (shoppingQuantity[17:15] == 3'b010)
						color <= two[{(counter_x-230)*20+counter_y-316}];
					else if (shoppingQuantity[17:15] == 3'b011)
						color <= three[{(counter_x-230)*20+counter_y-316}];
					else if (shoppingQuantity[17:15] == 3'b100)
						color <= four[{(counter_x-230)*20+counter_y-316}];
				end
			
			else if (counter_x>=250 && counter_x<260
			&& counter_y>=316 && counter_y<336 && listedItem>5)
				begin
					if (a[5] == 1)
						color <= one[{(counter_x-250)*20+counter_y-316}];
					else if (a[5] == 2)
						color <= two[{(counter_x-250)*20+counter_y-316}];
					else if (a[5] == 3)
						color <= three[{(counter_x-250)*20+counter_y-316}];
					else if (a[5] == 4)
						color <= four[{(counter_x-250)*20+counter_y-316}];
					else if (a[5] == 5)
						color <= five[{(counter_x-250)*20+counter_y-316}];
					else if (a[5] == 6)
						color <= six[{(counter_x-250)*20+counter_y-316}];
					else if (a[5] == 7)
						color <= seven[{(counter_x-250)*20+counter_y-316}];
					else if (a[5] == 8)
						color <= eight[{(counter_x-250)*20+counter_y-316}];
					else if (a[5] == 9)
						color <= nine[{(counter_x-250)*20+counter_y-316}];
					else if (a[5] == 0)
						color <= zero[{(counter_x-250)*20+counter_y-316}];						
				end
			else if (counter_x>=260 && counter_x<270
			&& counter_y>=316 && counter_y<336 && listedItem>5)
				begin
					if (b[5] == 1)
						color <= one[{(counter_x-260)*20+counter_y-316}];
					else if (b[5] == 2)
						color <= two[{(counter_x-260)*20+counter_y-316}];
					else if (b[5] == 3)
						color <= three[{(counter_x-260)*20+counter_y-316}];
					else if (b[5] == 4)
						color <= four[{(counter_x-260)*20+counter_y-316}];
					else if (b[5] == 5)
						color <= five[{(counter_x-260)*20+counter_y-316}];
					else if (b[5] == 6)
						color <= six[{(counter_x-260)*20+counter_y-316}];
					else if (b[5] == 7)
						color <= seven[{(counter_x-260)*20+counter_y-316}];
					else if (b[5] == 8)
						color <= eight[{(counter_x-260)*20+counter_y-316}];
					else if (b[5] == 9)
						color <= nine[{(counter_x-260)*20+counter_y-316}];
					else if (b[5] == 0)
						color <= zero[{(counter_x-260)*20+counter_y-316}];						
				end
				
			else if (counter_x>=270 && counter_x<275
			&& counter_y>=316 && counter_y<336 && listedItem>5)
				color <= dot[{(counter_x-270)*20+counter_y-316}];
				
			else if (counter_x>=275 && counter_x<285
			&& counter_y>=316 && counter_y<336 && listedItem>5)
				begin
					if (c[5] == 1)
						color <= one[{(counter_x-275)*20+counter_y-316}];
					else if (c[5] == 2)
						color <= two[{(counter_x-275)*20+counter_y-316}];
					else if (c[5] == 3)
						color <= three[{(counter_x-275)*20+counter_y-316}];
					else if (c[5] == 4)
						color <= four[{(counter_x-275)*20+counter_y-316}];
					else if (c[5] == 5)
						color <= five[{(counter_x-275)*20+counter_y-316}];
					else if (c[5] == 6)
						color <= six[{(counter_x-275)*20+counter_y-316}];
					else if (c[5] == 7)
						color <= seven[{(counter_x-275)*20+counter_y-316}];
					else if (c[5] == 8)
						color <= eight[{(counter_x-275)*20+counter_y-316}];
					else if (c[5] == 9)
						color <= nine[{(counter_x-275)*20+counter_y-316}];
					else if (c[5] == 0)
						color <= zero[{(counter_x-275)*20+counter_y-316}];						
				end
				
			else if (counter_x>=285 && counter_x<295
			&& counter_y>=316 && counter_y<336 && listedItem>5)
				begin
					if (d[5] == 1)
						color <= one[{(counter_x-285)*20+counter_y-316}];
					else if (d[5] == 2)
						color <= two[{(counter_x-285)*20+counter_y-316}];
					else if (d[5] == 3)
						color <= three[{(counter_x-285)*20+counter_y-316}];
					else if (d[5] == 4)
						color <= four[{(counter_x-285)*20+counter_y-316}];
					else if (d[5] == 5)
						color <= five[{(counter_x-285)*20+counter_y-316}];
					else if (d[5] == 6)
						color <= six[{(counter_x-285)*20+counter_y-316}];
					else if (d[5] == 7)
						color <= seven[{(counter_x-285)*20+counter_y-316}];
					else if (d[5] == 8)
						color <= eight[{(counter_x-285)*20+counter_y-316}];
					else if (d[5] == 9)
						color <= nine[{(counter_x-285)*20+counter_y-316}];
					else if (d[5] == 0)
						color <= zero[{(counter_x-285)*20+counter_y-316}];						
				end
			
			//Print first digit of the total cost
			else if (counter_x>=145 && counter_x<164
			&& counter_y>=446 && counter_y<484 && totalFlag==1)
				begin
					if (tFinal[0] == 1)
						color <= totalOne[{(counter_x-145)*38+counter_y-446}];
					else if (tFinal[0] == 2)
						color <= totalTwo[{(counter_x-145)*38+counter_y-446}];
					else if (tFinal[0] == 3)
						color <= totalThree[{(counter_x-145)*38+counter_y-446}];
					else if (tFinal[0] == 4)
						color <= totalFour[{(counter_x-145)*38+counter_y-446}];
					else if (tFinal[0] == 5)
						color <= totalFive[{(counter_x-145)*38+counter_y-446}];
					else if (tFinal[0] == 6)
						color <= totalSix[{(counter_x-145)*38+counter_y-446}];
					else if (tFinal[0] == 7)
						color <= totalSeven[{(counter_x-145)*38+counter_y-446}];
					else if (tFinal[0] == 8)
						color <= totalEight[{(counter_x-145)*38+counter_y-446}];
					else if (tFinal[0] == 9)
						color <= totalNine[{(counter_x-145)*38+counter_y-446}];
					else if (tFinal[0] == 0)
						color <= totalZero[{(counter_x-145)*38+counter_y-446}];						
				end
			
			//Print second digit of the total cost
			else if (counter_x>=164 && counter_x<183
			&& counter_y>=446 && counter_y<484 && totalFlag==1)
				begin
					if (tFinal[1] == 1)
						color <= totalOne[{(counter_x-164)*38+counter_y-446}];
					else if (tFinal[1] == 2)
						color <= totalTwo[{(counter_x-164)*38+counter_y-446}];
					else if (tFinal[1] == 3)
						color <= totalThree[{(counter_x-164)*38+counter_y-446}];
					else if (tFinal[1] == 4)
						color <= totalFour[{(counter_x-164)*38+counter_y-446}];
					else if (tFinal[1] == 5)
						color <= totalFive[{(counter_x-164)*38+counter_y-446}];
					else if (tFinal[1] == 6)
						color <= totalSix[{(counter_x-164)*38+counter_y-446}];
					else if (tFinal[1] == 7)
						color <= totalSeven[{(counter_x-164)*38+counter_y-446}];
					else if (tFinal[1] == 8)
						color <= totalEight[{(counter_x-164)*38+counter_y-446}];
					else if (tFinal[1] == 9)
						color <= totalNine[{(counter_x-164)*38+counter_y-446}];
					else if (tFinal[1] == 0)
						color <= totalZero[{(counter_x-164)*38+counter_y-446}];						
				end
			
			//Print third digit of the total cost
			else if (counter_x>=183 && counter_x<202
			&& counter_y>=446 && counter_y<484 && totalFlag==1)
				begin
					if (tFinal[2] == 1)
						color <= totalOne[{(counter_x-183)*38+counter_y-446}];
					else if (tFinal[2] == 2)
						color <= totalTwo[{(counter_x-183)*38+counter_y-446}];
					else if (tFinal[2] == 3)
						color <= totalThree[{(counter_x-183)*38+counter_y-446}];
					else if (tFinal[2] == 4)
						color <= totalFour[{(counter_x-183)*38+counter_y-446}];
					else if (tFinal[2] == 5)
						color <= totalFive[{(counter_x-183)*38+counter_y-446}];
					else if (tFinal[2] == 6)
						color <= totalSix[{(counter_x-183)*38+counter_y-446}];
					else if (tFinal[2] == 7)
						color <= totalSeven[{(counter_x-183)*38+counter_y-446}];
					else if (tFinal[2] == 8)
						color <= totalEight[{(counter_x-183)*38+counter_y-446}];
					else if (tFinal[2] == 9)
						color <= totalNine[{(counter_x-183)*38+counter_y-446}];
					else if (tFinal[2] == 0)
						color <= totalZero[{(counter_x-183)*38+counter_y-446}];						
				end
			
			//Print the dot 
			else if (counter_x>=202 && counter_x<213
			&& counter_y>=446 && counter_y<484 && totalFlag==1)
				color <= totalDot[{(counter_x-202)*38+counter_y-446}];
			
			//Print fourth digit of the total cost
			else if (counter_x>=213 && counter_x<232
			&& counter_y>=446 && counter_y<484 && totalFlag==1)
				begin
					if (tFinal[3] == 1)
						color <= totalOne[{(counter_x-213)*38+counter_y-446}];
					else if (tFinal[3] == 2)
						color <= totalTwo[{(counter_x-213)*38+counter_y-446}];
					else if (tFinal[3] == 3)
						color <= totalThree[{(counter_x-213)*38+counter_y-446}];
					else if (tFinal[3] == 4)
						color <= totalFour[{(counter_x-213)*38+counter_y-446}];
					else if (tFinal[3] == 5)
						color <= totalFive[{(counter_x-213)*38+counter_y-446}];
					else if (tFinal[3] == 6)
						color <= totalSix[{(counter_x-213)*38+counter_y-446}];
					else if (tFinal[3] == 7)
						color <= totalSeven[{(counter_x-213)*38+counter_y-446}];
					else if (tFinal[3] == 8)
						color <= totalEight[{(counter_x-213)*38+counter_y-446}];
					else if (tFinal[3] == 9)
						color <= totalNine[{(counter_x-213)*38+counter_y-446}];
					else if (tFinal[3] == 0)
						color <= totalZero[{(counter_x-213)*38+counter_y-446}];						
				end
			
			//Print fifth digit of the total cost
			else if (counter_x>=232 && counter_x<251
			&& counter_y>=446 && counter_y<484 && totalFlag==1)
				begin
					if (tFinal[4] == 1)
						color <= totalOne[{(counter_x-232)*38+counter_y-446}];
					else if (tFinal[4] == 2)
						color <= totalTwo[{(counter_x-232)*38+counter_y-446}];
					else if (tFinal[4] == 3)
						color <= totalThree[{(counter_x-232)*38+counter_y-446}];
					else if (tFinal[4] == 4)
						color <= totalFour[{(counter_x-232)*38+counter_y-446}];
					else if (tFinal[4] == 5)
						color <= totalFive[{(counter_x-232)*38+counter_y-446}];
					else if (tFinal[4] == 6)
						color <= totalSix[{(counter_x-232)*38+counter_y-446}];
					else if (tFinal[4] == 7)
						color <= totalSeven[{(counter_x-232)*38+counter_y-446}];
					else if (tFinal[4] == 8)
						color <= totalEight[{(counter_x-232)*38+counter_y-446}];
					else if (tFinal[4] == 9)
						color <= totalNine[{(counter_x-232)*38+counter_y-446}];
					else if (tFinal[4] == 0)
						color <= totalZero[{(counter_x-232)*38+counter_y-446}];						
				end
			
			//Print the letter T
			else if (counter_x>=260 && counter_x<279
			&& counter_y>=446 && counter_y<484 && totalFlag==1)
				color <= totalT[{(counter_x-260)*38+counter_y-446}];
				
			//Print the letter L
			else if (counter_x>=279 && counter_x<298
			&& counter_y>=446 && counter_y<484 && totalFlag==1)
				color <= totalL[{(counter_x-279)*38+counter_y-446}];
			
			else
				color <= 8'hFF;// default color is printed
		end


	
	// color output assignments
	// only output the colors if the counters are within the visible area, otherwise output 0
	assign o_color = ( (counter_x > h_sync_pulse + h_back_porch) && (counter_x <= h_sync_pulse + h_back_porch + h_visible_area) && (counter_y>v_sync_pulse+v_back_porch) && (counter_y <= v_sync_pulse + v_back_porch + v_visible_area) ) ? color : 8'b00000000;
	
endmodule  