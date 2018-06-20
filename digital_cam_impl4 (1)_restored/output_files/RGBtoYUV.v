module RGBtoYUV(R, G, B, Y, U, V, clock, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, ActiveArea, Hcnt, Vcnt);

	input clock;
	//input KEY;
	input [7:0] R, G, B;
	
	input wire ActiveArea; 
	input wire [9:0] Hcnt, Vcnt;
	
	wire [9:0] dispCol;
	wire [9:0] dispRow;
	assign dispCol = Hcnt;
	assign dispRow = Vcnt;
	
	output reg [7:0] Y,U,V;
	reg [7:0] newY,newU,newV;
	output wire [6:0] HEX0,HEX1,HEX2 ,HEX3,HEX4,HEX5 ;
	
	//wire reset;
	//assign reset = !KEY;
	
	parameter HOR_TOTAL = 320; //640
	parameter VER_TOTAL = 240; //480

	
	reg [9:0] xpositie,xpos, ypos;
	reg [31:0] cnt;
	reg [1:0] resetbool;
	
	reg [63:0] integraaly_teller, integraaly_noemer, integraalx_teller,integraalx_noemer ;
	
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
	 
	 //Game game(.clk(clock), .barx(xpos), .red(R), .green(G), .blue(B), .visile(ActiveArea), .col(dispCol), .row(dispRow));
	 

	always @(posedge clock)
			begin
						
			/*if (cnt < 5000000)
					begin
						cnt = cnt + 1;
						end
				else
					begin
						cnt = 0;
						
						if (dispCol>xpos)
						begin
							xpos = dispCol;
							
						end
						
						if (dispRow>ypos)
						begin
							ypos = dispRow;
						end

					end*/
						 
			
			
			//testbool = 0;
			
			if (resetbool)
				begin
				resetbool = 0;
				//dispCol =11'b0;
				//dispRow = 10'b0;
				
				integraaly_teller =63'b0;
				integraaly_noemer =63'b0;
				
				integraalx_teller =63'b0;
				integraalx_noemer =63'b0;
				end
				
						
			if (cnt < 5000000)
					begin
						cnt = cnt + 1;
						end
				else
					begin
						cnt = 0;
					
						xpos = xpositie;
						
						
					end
						 
			if (dispCol == HOR_TOTAL)
				begin
				//dispCol =11'b0;
				if (dispRow == VER_TOTAL)
					begin
					//dispRow = 10'b0;
					//Xpos berekenen
				
					xpositie = integraaly_teller/integraaly_noemer;
					resetbool = 1;
				
					end
				else 
					begin

					integraaly_teller = integraaly_teller + integraalx_teller;
					integraaly_noemer = integraaly_noemer + integraalx_noemer;
					
					//dispRow = dispRow + 1;
					
					integraalx_teller = 63'b0;
					integraalx_noemer = 63'b0;
					end
				end
		else
			begin
			//dispCol = dispCol +1;
			
			newU = (R - G);
			
			if (newU > 10 && newU <74)
				begin
				Y = 255;
				U = 255;
				V = 255;
				integraalx_teller = integraalx_teller + (dispCol * 1);
				integraalx_noemer = integraalx_noemer + 1;
				
				//integraalx_teller = integraalx_teller + (dispRow * newU);
				//integraalx_noemer = integraalx_noemer + newU;
				end
			else
				begin
				Y = 0;
				U = 0;
				V = 0;
				
				//integraalx_teller = integraalx_teller + 0;
				//integraalx_noemer = integraalx_noemer + 0;
				end

		end
				
	end	

endmodule

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
