/* color_data.sv
 *
 * Index from text file determines color output.
 * Should match color palette in python code.
 */
module color_data ( input [1:0]	index,
						  output [7:0] sprite_r,
											sprite_g,
											sprite_b
							);

always_comb
	begin
		case(index)
			2'd0 : //white
				begin
					sprite_r = 8'hff;
					sprite_g = 8'hff;
					sprite_b = 8'hff;
				end
			2'd1 : //black
				begin
					sprite_r = 8'h00;
					sprite_g = 8'h00;
					sprite_b = 8'h00;
				end
			2'd2 : //green
				begin
					sprite_r = 8'h00;
					sprite_g = 8'hff;
					sprite_b = 8'h00;
				end
			2'd3 : //red
				begin
					sprite_r = 8'hff;
					sprite_g = 8'h00;
					sprite_b = 8'h00;
				end
			default :
				begin
					sprite_r = 8'bXXXXXXXX;
					sprite_g = 8'bXXXXXXXX;
					sprite_b = 8'bXXXXXXXX;
				end
		endcase
	end

endmodule




module controller ( input	logic   Clk,
                                  Reset,
							output logic [1:0] choose_cannon,
							output logic [2:0] choose_laser,
							output logic [3:0] choose_enemy,
							output logic [4:0] choose_letter,
							output logic [2:0] choose_punct,
							output logic [3:0] choose_number
							);

	enum logic [4:0] { Start } State, Next_state; //Internal state logic

  always_ff @ (posedge Clk)
  begin
    if (Reset)
      State <= Start;
    else
      State <= Next_state;

  end

  always_comb
  begin
    // Default next state is staying at current state
    Next_state = State;

    // Default controls signal values
    choose_cannon = 2'b00; //normal cannon
    choose_laser = 3'b000; //normal laser
    choose_enemy = 3'b000; //10pt laser pos 1
    choose_letter = 5'b00000; //A
    choose_punct = 3'b000; //=
    choose_number = 4'b0000; //0

    // Assign next state
    unique case (State)
      Start : ;

      default : ;

    endcase

    // Assign control signals based on current state
    case (State)
      Start : ;

      default : ;

    endcase
  end


endmodule
