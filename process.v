`timescale 1ns / 1ps


module process(
    input clk,                // clock 
    input [23:0] in_pix,    // valoarea pixelului de pe pozitia [in_row, in_col] din imaginea de intrare (R 23:16; G 15:8; B 7:0)
    output reg [5:0] row, col,     // selecteaza un rand si o coloana din imagine
    output reg out_we,             // activeaza scrierea pentru imaginea de iesire (write enable)
    output reg [23:0] out_pix,    // valoarea pixelului care va fi scrisa in imaginea de iesire pe pozitia [out_row, out_col] (R 23:16; G 15:8; B 7:0)
    output reg mirror_done = 0,        // semnaleaza terminarea actiunii de oglindire (activ pe 1)
    output reg gray_done = 0,        // semnaleaza terminarea actiunii de transformare in grayscale (activ pe 1)
    output reg filter_done = 0);    // semnaleaza terminarea actiunii de aplicare a filtrului de sharpness (activ pe 1)

	// TODO add your finite state machines here
	reg [23:0] cache_pix[1:0]; // memorarea temporara a pixelilor pentru procesare
	reg[7:0] min_pix, max_pix, r_pix, g_pix, b_pix; // variabile pentru manipularea valorilor pixelilor
	reg [5:0] state = 0, next_state = 0; // starile curente si urmatoare pentru FSM


   always @(posedge clk) begin
	
		state = next_state;	// actualizeaza state
		
       case(state) 
		 // Mirror
			0 : begin // initializare

					out_we = 0;    
					row = 0;
					col = 0; 
					mirror_done = 0;
					gray_done = 0;
					filter_done = 0;
					
					next_state = 1;
				end 
								
			1 : begin	
					cache_pix[0] = in_pix; // stocheaza pixelul curent
					
					next_state = 2;
					
				end 					


							
			2 : begin 

					row = 63 - row; // calculeaza oglindirea randului
					next_state = 3;
					
				end 
			
			3 : begin 
								
					
					cache_pix[1] = in_pix; // stocheaza pixelul pentru oglindire
					
					next_state = 4;
					
				end 
			
			4 : begin 
					out_we = 1; // activeaza scrierea
					
					out_pix = cache_pix[0]; // scrie pixelul oglindit
					
					next_state = 5;
				end 
								
			5 : begin 
					out_we = 0; // dezactiveaza scrierea
					row = 63 - row; // restabileste pozitia originala a randului
					next_state = 6;

				end 
				
			6: begin 
					out_we = 1; // activeaza scrierea
					
					out_pix = cache_pix[1]; // scrie al doilea pixel oglindit
					
					next_state = 7;

				end 
								
			7: begin
							
					out_we = 0; // dezactiveaza scrierea
					row = row + 1; // incrementeaza randul
					next_state = 8;
					
				end 
			
			8: begin 
							
					if(row == 32) begin
						col  = col + 1; // incrementeaza coloana daca este necesar
						row = 0; // reseteaza randul
					end
					next_state = 9;
					
				end 
				
			9: begin 
					if(col == 0 && row == 0) begin 
						mirror_done = 1; // indica finalizarea procesului de oglindire
						col = 0;
						row = 0;
						cache_pix[0] = 0;
						cache_pix[1] = 0;
						
						next_state = 10; // trecere la urmatoarea stare pentru grayscale
					end else begin 
						next_state = 1; // repeta procesul de oglindire pentru restul pixelilor
					end 

				end
					
			// Grayscale transformation			
					
			10	: begin 
						
						cache_pix[0] = in_pix; // stocheaza pixelul curent
						next_state = 11;
						
					end
					
			11 : begin 
			
						r_pix = cache_pix[0] >> 16; // extragerea componentei rosii
						g_pix = cache_pix[0] >> 8; // extragerea componentei verzi
						b_pix = cache_pix[0]; // etragerea componentei albastre
						
						next_state = 12;
					
					end
					
			12: begin 
						// determinarea valorii maxime si minime dintre componentele de culoare

						if(r_pix > g_pix && r_pix > b_pix) begin
							max_pix = r_pix; // componenta rosie este maxima
						end else if (g_pix > b_pix) begin
							max_pix = g_pix; // componenta verde este maxima
						end else begin
							max_pix = b_pix; // componenta albastra este maxima
						end
						
						if(r_pix < g_pix && r_pix < b_pix) begin
							min_pix = r_pix; // componenta rosie este minima
						end else if (g_pix < b_pix) begin
							min_pix = g_pix; // componenta verde este minima
						end else begin
							min_pix = b_pix; // componenta albastra este minima
						end
						
						next_state = 13;
						
					end
					
			13 : begin
						// calculul valorii grayscale prin media maximului si minimului
							
						cache_pix[1] = (min_pix + max_pix) / 2;
						
						next_state = 14;
						
					end
					
			14 : begin 
						
						out_we = 1; // activeaza scrierea
						out_pix = cache_pix[1] << 8; // scrie valoarea grayscale
						next_state = 15;
						
					end
					
			15 : begin 
					
						out_we = 0; // dezactiveaza scrierea
						row = row + 1; // incrementeaza randul
						next_state = 16;
					
					end
					
			16: begin 
							
						if(row == 0) begin
							col = col + 1; // incrementeaza coloana daca este necesar
						
						end 
						next_state = 17;
					end
			
			17: begin 
						
						if(col == 0 && row == 0) begin
							gray_done = 1; // indica finalizarea transformarii în grayscale
							next_state = 18; // trecere la urmatoarea stare pentru filtrul sharp
						end else begin
							next_state = 10; // repeta procesul pentru restul pixelilor

						end 
				end
				
			// Filter sharp				
			18: begin 
						
						
					end




				

		endcase
	end

endmodule
