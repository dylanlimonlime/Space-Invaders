//-------------------------------------------------------------------------
//    laser.sv                                               --
//-------------------------------------------------------------------------


module  laser ( input        Clk,                // 50 MHz clock
									  Reset,              // Active-high reset signal
									  frame_clk,          // The clock indicating a new frame (~60Hz)
					 input [9:0]  DrawX, DrawY,       // Current pixel coordinates
					 input [7:0]  keycode1,				//8-bit input from keyboard
					 input [9:0]  Cannon_X_Pos_in, 
					 output logic is_laser             // Whether current pixel belongs to ball or background
					 );
    
    parameter [9:0] laser_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] laser_Y_Center = 10'd240;  // Center position on the Y axis
	 parameter [9:0] laser_Y_Reset_pos = 10'd470; // laser's position on Y axis for reset
    parameter [9:0] laser_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] laser_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] laser_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] laser_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] laser_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] laser_Y_Step = 10'd7;      // Step size on the Y axis
    parameter [9:0] laser_Size = 10'd2;        // laser size
    
    logic [9:0] laser_X_Pos, laser_X_Motion, laser_Y_Pos, laser_Y_Motion;
    logic [9:0] laser_X_Pos_in, laser_X_Motion_in, laser_Y_Pos_in, laser_Y_Motion_in;
	 
	 logic key_press_in, key_press, laser_on_in, laser_on;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
				//laser should not exist yet
            laser_X_Pos <= laser_X_Center;
            laser_Y_Pos <= laser_Y_Reset_pos;
            laser_X_Motion <= 10'd0;
            laser_Y_Motion <= 10'd0;
				key_press_in <= 1'b0;
				laser_on <= 1'b0;
        end
        else
        begin
            laser_X_Pos <= laser_X_Pos_in;
            laser_Y_Pos <= laser_Y_Pos_in;
            laser_X_Motion <= laser_X_Motion_in;
            laser_Y_Motion <= laser_Y_Motion_in;
				key_press <= key_press_in;
				laser_on <= laser_on_in;
        end
    end
	 
    always_comb
    begin
        // By default, keep motion and position unchanged
        laser_X_Pos_in = laser_X_Pos;
        laser_Y_Pos_in = laser_Y_Pos;
        laser_X_Motion_in = laser_X_Motion;
        laser_Y_Motion_in = laser_Y_Motion;
		  laser_on_in = laser_on;
		  //key_press_in = key_press;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. laser_Y_Pos - laser_Size <= laser_Y_Min 
            // If laser_Y_Pos is 0, then laser_Y_Pos - laser_Size will not be -4, but rather a large positive number.
				case(keycode1)
						//space
						/* if laser exists and is not at top of screen*/
						/* motion_in = motion */
						/* if laser dne */
						/* fire laser */
					1'b1: begin	
						if(laser_on && (laser_Y_Pos <= laser_Y_Min + laser_Size)) begin
							laser_X_Motion_in = Cannon_X_Pos_in;
							laser_Y_Motion_in = (~(laser_Y_Step) + 1'b1);
							laser_Y_Pos_in = laser_Y_Pos + laser_Y_Motion;
							laser_on_in = 1'b0;
							end
						if(laser_on && (laser_Y_Pos > laser_Y_Min + laser_Size)) begin
							laser_X_Motion_in = laser_X_Motion;
							laser_Y_Motion_in = (~(laser_Y_Step) + 1'b1);
							laser_Y_Pos_in = laser_Y_Pos + laser_Y_Motion;
							laser_on_in = 1'b1;
							end
						else begin
						   laser_X_Motion_in = Cannon_X_Pos_in;
							laser_Y_Pos_in = laser_Y_Reset_pos;
							laser_Y_Motion_in = (~(laser_Y_Step) + 1'b1);
							laser_on_in = 1'b1;
							end						
						end
							
					default: begin
					
						//laser_X_Motion_in = 10'd400;
						if(laser_on && (laser_Y_Pos <= laser_Y_Min + laser_Size)) begin
							laser_X_Motion_in = Cannon_X_Pos_in;
							laser_Y_Motion_in = (~(laser_Y_Step) + 1'b1);
							laser_Y_Pos_in = laser_Y_Pos + laser_Y_Motion;
							laser_on_in = 1'b0;
							end
						if(laser_on && (laser_Y_Pos > laser_Y_Min + laser_Size)) begin
							laser_X_Motion_in = laser_X_Motion;
							laser_Y_Motion_in = (~(laser_Y_Step) + 1'b1);
							laser_Y_Pos_in = laser_Y_Pos + laser_Y_Motion;
							laser_on_in = 1'b1;
							end
						else begin
							laser_X_Motion_in = Cannon_X_Pos_in;
							laser_Y_Motion_in = 10'd0;
							laser_Y_Pos_in = 10'd470;
							laser_on_in = 1'b0;
							end
						end
					endcase
				
				//Update the laser's position with its motion
				laser_X_Pos_in = laser_X_Motion;
		end
        

    end
    
    // Compute whether the pixel corresponds to laser or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - laser_X_Pos;
    assign DistY = DrawY - laser_Y_Pos;
    assign Size = laser_Size;
    always_comb begin
        if ( ( (DistX*DistX + DistY*DistY) <= (Size*Size) ) && (laser_on)) 
            is_laser = 1'b1;
        else
            is_laser = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end
    
endmodule
