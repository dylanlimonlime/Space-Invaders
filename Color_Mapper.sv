//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_cannon,            // Whether current pixel belongs to ball
                                                              //   or background (computed in ball.sv)
														is_laser,
                       input        [1:0] choose_cannon,
                       input        [2:0] choose_laser,
                       input        [3:0] choose_enemy,
                       input        [4:0] choose_letter,
                       input        [2:0] choose_punct,
                       input        [3:0] choose_number,

                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );

    logic [7:0] Red, Green, Blue;
    logic [7:0] pixel_color_r, pixel_color_g, pixel_color_b;
    logic [1:0] index;

    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

    color_data sprite_color_index (.index(index),
                                   .sprite_r(pixel_color_r),
                                   .sprite_g(pixel_color_g),
                                   .sprite_b(pixel_color_b)
                                   );
    laser_cannon cannon_sprite( .read_address(), .Clk(Clk), .choose_cannon(.choose_cannon), .data_Out(index) );
    laser_png    laser_png_sprite( .read_address(), .Clk(Clk), .choose_laser(.choose_laser), .data_Out(index) );
    bunker       bunker_sprite( .read_address(), .Clk(Clk), .data_Out(index) );
    enemy        enemy_sprite( .read_address(), .Clk(Clk), .choose_enemy(.choose_enemy), .data_Out(index) );
    alphabet     alphabet_sprite( .read_address(), .Clk(Clk), .choose_letter(.choose_letter), .data_Out(index) );
    punctuation  punct_sprite( .read_address(), .Clk(Clk), .choose_punct(.choose_punct), .data_Out(index) );
    numbers      num_sprite( .read_address(), .Clk(Clk), .choose_number(.choose_number), .data_Out(index) );


    // Assign color based on is_cannon signal
    always_comb
    begin
        if (is_cannon == 1'b1)
        begin
            // Bright green ball
				Red = 8'h55;
            Green = 8'hff;
            Blue = 8'h55;
        end
		  else if (is_laser == 1'b1)
		  begin
				// White laser
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
        else
        begin
				// Black background
				Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
            // Background with nice color gradient
//            Red = 8'h3f;
//            Green = 8'h00;
//            Blue = 8'h7f - {1'b0, DrawX[9:3]};
        end

/*
        if () //cannon, laser, enemy, bunker, score
        begin //draw sprite and match color
          Red = pixel_color_r;
          Green = pixel_color_g;
          Blue = pixel_color_b;
        end
        else //draw background
        begin
          // Black background
          Red = 8'h00;
          Green = 8'h00;
          Blue = 8'h00;
        end
*/
    end



endmodule
