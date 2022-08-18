/* alien_control.sv
 *
 * array of alien control signals
 *
 */

module  alien_control ( input logic CLK,						//50 MHz clock
												RESET,					//active high reset
//												frame_clk,          // The clock indicating a new frame (~60Hz) ??????????
								input [9:0]   DrawX, DrawY,       // Current pixel coordinates
								
								output logic is_alien0, 
												 is_alien1, 
												 is_alien2, 
												 is_alien3, 
												 is_alien4, 
												 is_alien5, 
												 is_alien6, 
												 is_alien7, 
												 is_alien8, 
												 is_alien9, 
												 is_alien10
								);
								
	
	logic [41:0] array[5]; //5 rows of 11 aliens
	
	
	always_ff @(posedge CLK) begin
	if(RESET) //initalize with all aliens
		begin
			for(int i=0; i<5; i++) begin
				array[i] <= 42'b000000100100100100100100100100100100100000; 
			end
		end
	else if (array[0][0] != 1 || array[1][0] != 1 || array[2][0] != 1 || array[3][0] !=1 || array[4][0] != 1) 
		begin
			for(int i=0; i<5; i++) begin
				array[i] <= array[i] >> 1; //right-shift by 1 for every clock cycle
			end
		end
	else if ()
		begin
			for(int i=0; i<5; i++) begin
				array[i] <= array[i] << 1; //left-shift by 1 for every clock cycle
			end
		end
	else if (array[0][0] == 1 || array[1][0] == 1 || array[2][0] == 1 || array[3][0] ==1 || array[4][0] == 1)
	//x-pos of farthest right alien or farthest left alien == boundary
		begin
			for(int i=0; i<5; i++) begin
				//everything should move down
			end
		end

 
	
	end
								
								
endmodule

