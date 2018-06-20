module RGBtoYUV(R, G, B, Y, U, V, clock, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, ActiveArea, Hcnt, Vcnt, game_modus);

	input clock;
	input wire [1:0] game_modus;
	reg [1:0] test_game_modus;
	input [7:0] R, G, B;
	
	input wire ActiveArea; 
	input wire [9:0] Hcnt, Vcnt;
	
	wire [9:0] col;
	wire [9:0] row;
	assign col = Hcnt;
	assign row = Vcnt;
	
	output [7:0] Y,U,V;
	//output reg [7:0] Y,U,V;
	reg [7:0] newU;
	output wire [6:0] HEX0,HEX1,HEX2 ,HEX3,HEX4,HEX5 ;
	
	//wire reset;
	//assign reset = !KEY;
	
	reg [9:0] xpos;
	reg [9:0] xpositie;
	reg [31:0] cnt;
	
	reg [63:0] integraaly_teller, integraaly_noemer, integraalx_teller,integraalx_noemer ;
	reg [1:0] resetbool;
	parameter HOR_TOTAL = 640; //640
	parameter VER_TOTAL = 480; //480
	
	 binToHex bth(.in(xpos%10), .out(HEX0));
	 binToHex bth1(.in((xpos/10)%10), .out(HEX1));
    binToHex bth2(.in((xpos/100)%10), .out(HEX2));	 
	 
	 binToHex bth3(.in(ypos%10), .out(HEX3));
	 binToHex bth4(.in((ypos/10)%10), .out(HEX4));
    binToHex bth5(.in((ypos/100)%10), .out(HEX5));
	
	 
	 /*binToHex bth(.in(xpos%10), .out(HEX0));
	 binToHex bth1(.in((xpos/10)%10), .out(HEX1));
    binToHex bth2(.in((xpos/100)%10), .out(HEX2));	 
	 
	 binToHex bth3(.in((ypos/1000)%10), .out(HEX3));
	 binToHex bth4(.in((ypos/10000)%10), .out(HEX4));
    binToHex bth5(.in((ypos/100000)%10), .out(HEX5));*/
	 
	 wire [15:0] lfsrout;
	 
	 //Centroid centroid(.clock(clock), .R(R), .G(G), .B(B), .Y(Y), .U(U), .V(V), .xpositie(xpositie), .row(row), .col(col), .game_modus(test_game_modus));
	 Game game(.clock(clock), .barx(xpos), .red(Y), .green(U), .blue(V), .visible(ActiveArea), .row(row), .col(col), .random(lfsrout));
	 //LFSR lfsr(.clk(clock), .clken(1), .out(lfsrout));

	always @(posedge clock)
	begin			
				
		if (cnt < 5000000)
			begin
				cnt = cnt + 1;
			end
		else
			begin
				cnt = 0;
				xpos = xpositie*2;
			end	
			
			if (resetbool)
				begin
				resetbool = 0;

				integraaly_teller =63'b0;
				integraaly_noemer =63'b0;
				
				integraalx_teller =63'b0;
				integraalx_noemer =63'b0;
				end
				
			if (col == HOR_TOTAL)
				begin
				if (row == VER_TOTAL)
					begin
					
					//X Positie berekenen
					xpositie = integraaly_teller/integraaly_noemer;
					resetbool = 1;
				
					end
				else 
					begin

					integraaly_teller = integraaly_teller + integraalx_teller;
					integraaly_noemer = integraaly_noemer + integraalx_noemer;
					
					integraalx_teller = 63'b0;
					integraalx_noemer = 63'b0;
					end
				end
		else
			begin
		
			newU = (R - G);
			
			if (newU > 10 && newU <74)
				begin
				/*if (!game_modus)
					begin
					Y = 255;
					U = 255;
					V = 255;
					/*end*/
				integraalx_teller = integraalx_teller + (col * 1);
				integraalx_noemer = integraalx_noemer + 1;

				end
			else
				begin
				/*if (!game_modus)
					begin
					Y = 0;
					U = 0;
					V = 0;
					/*end*/
				end
			end
	end	

endmodule

/*module Centroid(clock, R, G, B, Y, U, V, xpositie, row, col, game_modus);

	input wire [1:0] game_modus;
	reg [63:0] integraaly_teller, integraaly_noemer, integraalx_teller,integraalx_noemer ;
	input wire clock;
	
	input [7:0] R, G, B;
	output reg [7:0] Y,U,V;
   reg [7:0] newU;
	
	output reg [9:0] xpositie;
	reg [31:0] cnt;
	reg [1:0] resetbool;
		
	input wire [9:0] row;
	input wire [9:0] col;
	
	
	parameter HOR_TOTAL = 640; //640
	parameter VER_TOTAL = 480; //480
	
	always @(posedge clock)
			begin
			
			if (resetbool)
				begin
				resetbool = 0;

				integraaly_teller =63'b0;
				integraaly_noemer =63'b0;
				
				integraalx_teller =63'b0;
				integraalx_noemer =63'b0;
				end
				
			if (col == HOR_TOTAL)
				begin
				if (row == VER_TOTAL)
					begin
					
					//X Positie berekenen
					xpositie = integraaly_teller/integraaly_noemer;
					resetbool = 1;
				
					end
				else 
					begin

					integraaly_teller = integraaly_teller + integraalx_teller;
					integraaly_noemer = integraaly_noemer + integraalx_noemer;
					
					integraalx_teller = 63'b0;
					integraalx_noemer = 63'b0;
					end
				end
		else
			begin
		
			newU = (R - G);
			
			if (newU > 10 && newU <74)
				begin
				if (!game_modus)
					begin
					Y = 255;
					U = 255;
					V = 255;
					end
				integraalx_teller = integraalx_teller + (col * 1);
				integraalx_noemer = integraalx_noemer + 1;

				end
			else
				begin
				if (!game_modus)
					begin
					Y = 0;
					U = 0;
					V = 0;
					end
				end

			end
			end
endmodule
*/

module Game (clock, barx, red, green, blue, visible, row, col, random);
	input wire clock;
	output reg [7:0] red;
	output reg [7:0] green;
	output reg [7:0] blue;
	
	 reg [9:0] ballx;
	 reg xneg, yneg;
	 reg [9:0] bally;
	
	input wire [9:0] barx;
   reg [9:0] bary;
	
	input wire [9:0] row;
	input wire [9:0] col;

	reg [31:0] cnt;
	input wire [15:0] random;
	
	input wire visible;
	parameter HOR_TOTAL = 640; //640
	parameter VER_TOTAL = 480; //480
	
	//LFSR lfsr(.clk(clock), .clken(1), .out(lfsrout));
	
always @(posedge clock )
	begin
	bary = (VER_TOTAL/4) * 3;
		/*if (reset)
		begin
			red = 0;
			green = 0;
			blue = 0;
			
			ballx = 0;
			bally = 0;

			
			//barx = (HOR_TOTAL/2) - 10 ;
			bary = (VER_TOTAL/4) * 3;
			
			xneg = 0;
			yneg = 0;
		end
		else
		begin*/
			
				if (cnt < 500000)
				begin
					cnt = cnt + 1;
				end
				else
				begin
					cnt = 0;
					ballx = ballx+1;
					bally = bally + 1;
						
					if (ballx <= 30)
						xneg = 0;
					if (ballx >= (HOR_TOTAL-30)) //1280 - 32
						xneg = 1;
					if (bally <= 30)
						yneg = 0;
					if (bally >= (VER_TOTAL-30)) // 1024 - 32
						yneg = 1;
						
					// Ball VS BAR
					if ( (bally + 32 >= bary) && (ballx + 32 >= barx || ballx <= barx+96) )
						yneg = 1;
					
					if (xneg)
						//ballx = ballx - random[1:0];
						ballx = ballx - 5;
					else
						//ballx = ballx + random[1:0];
						ballx = ballx + 5;
					
					if (yneg)
						//bally = bally - random[3:2];
						bally = bally - 3;
					else
						//bally = bally + random[3:2];
						bally = bally + 3;
				     
				end
				
				
				
				if (col > ballx && col < ballx + 32 && row > bally && row < bally + 32)
				begin
					red = 255;
					green = 255;
					blue = 255;
				end
				else if (col > barx && col < barx +96 && row > bary && row < bary + 32)
				begin
					red = 255;
					green = 20;
					blue = 20;
				end
				
				else
				begin
					red= 0;
					green = 0;
					blue = 0;
				end
			end
	//end
	
endmodule

/*module LFSR(clk,clken,out);
	
	input clk;
	input clken;
	
	output reg [15:0] out;
	
	wire feedback = ((out[15] ^ out[13]) ^ out[12]) ^ out[10];
	
	always @(posedge clk)
	begin
		if (clken)
			begin
				out = {out[14:0], feedback};
			end
	end
endmodule
	*/

module binToHex(in, out);
	output reg [7:0] out;
	input [3:0] in;
	
	always @*
	begin
	case (in)
				 0 : out = ~7'b0111111;
				 1 : out = ~7'b0000110;
				 2 : out = ~7'b1011011;
				 3 : out = ~7'b1001111;
				 4 : out = ~7'b1100110;
				 5 : out = ~7'b1101101;
				 6 : out = ~7'b1111101;
				 7 : out = ~7'b0000111;
				 8 : out = ~7'b1111111;
				 9 : out = ~7'b1101111;
				 10: out = ~7'b1110111;
				 11: out = ~7'b1111100;
				 12: out = ~7'b0111001;
				 13: out = ~7'b1011110;
				 14: out = ~7'b1111001;
				 15: out = ~7'b1110001;
				 default : out =  ~7'b1110111;
	endcase
	end
endmodule
