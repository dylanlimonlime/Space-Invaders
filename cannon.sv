//-------------------------------------------------------------------------
//    cannon.sv                                               --
//-------------------------------------------------------------------------


module  cannon ( input        Clk,                // 50 MHz clock
										Reset,              // Active-high reset signal
										frame_clk,          // The clock indicating a new frame (~60Hz)
					input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [7:0] left, right,
					output logic  is_cannon,             // Whether current pixel belongs to ball or background
					output logic [9:0] Cannon_X_Pos_in
					);
    
    parameter [9:0] Cannon_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Cannon_Y_Center = 10'd240;  // Center position on the Y axis
	 parameter [9:0] Cannon_Y_Reset_pos = 10'd470; // Cannon's position on Y axis for reset
    parameter [9:0] Cannon_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Cannon_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Cannon_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Cannon_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Cannon_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] Cannon_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Cannon_Size = 10'd4;        // Cannon size
    
    logic [9:0] Cannon_X_Pos, Cannon_X_Motion, Cannon_Y_Pos, Cannon_Y_Motion;
//    logic [9:0] Cannon_X_Pos_in, Cannon_X_Motion_in, Cannon_Y_Pos_in, Cannon_Y_Motion_in;
    logic [9:0] Cannon_X_Motion_in, Cannon_Y_Pos_in, Cannon_Y_Motion_in;

    
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
				//laser cannon should start at center at bottom
            Cannon_X_Pos <= Cannon_X_Center;
            Cannon_Y_Pos <= Cannon_Y_Reset_pos;
            Cannon_X_Motion <= 10'd0;
            Cannon_Y_Motion <= 10'd0;
        end
        else
        begin
            Cannon_X_Pos <= Cannon_X_Pos_in;
            Cannon_Y_Pos <= Cannon_Y_Pos_in;
            Cannon_X_Motion <= Cannon_X_Motion_in;
            Cannon_Y_Motion <= Cannon_Y_Motion_in;
        end
//		  keycode1 <= keycode;
    end
    
    always_comb
    begin
        // By default, keep motion and position unchanged
        Cannon_X_Pos_in = Cannon_X_Pos;
        Cannon_Y_Pos_in = Cannon_Y_Pos;
        Cannon_X_Motion_in = Cannon_X_Motion;
        Cannon_Y_Motion_in = Cannon_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Cannon_Y_Pos - Cannon_Size <= Cannon_Y_Min 
            // If Cannon_Y_Pos is 0, then Cannon_Y_Pos - Cannon_Size will not be -4, but rather a large positive number.
				//case (keycode)						
					if(left) begin
							//left
							//Cannon_X_Motion_in = (~(Cannon_X_Step) + 1'b1);
							Cannon_Y_Motion_in = 10'd0;
//							if( Cannon_X_Pos + Cannon_Size >= Cannon_X_Max )  // Cannon is at the right edge
//								Cannon_X_Motion_in = 10'd0;  // keep position same  
							if ( Cannon_X_Pos <= Cannon_X_Min + Cannon_Size )  // Cannon is at the left edge
								Cannon_X_Motion_in = 10'd0;  // keep position same  
							else
								Cannon_X_Motion_in = (~(Cannon_X_Step) + 1'b1);
						end
								
					else if(right) begin
							//right
							//Cannon_X_Motion_in = Cannon_X_Step;
							Cannon_Y_Motion_in = 10'd0;
							if( Cannon_X_Pos + Cannon_Size >= Cannon_X_Max )  // Cannon is at the right edge
								Cannon_X_Motion_in = 10'd0;  // keep position same  
//							else if ( Cannon_X_Pos <= Cannon_X_Min + Cannon_Size )  // Cannon is at the left edge
//								Cannon_X_Motion_in = 10'd0;  // keep position same  
							else
								Cannon_X_Motion_in = Cannon_X_Step;
						end

							
					else begin
									
//							Cannon_X_Motion_in = Cannon_X_Motion;
							Cannon_X_Motion_in = 10'd0;
							Cannon_Y_Motion_in = Cannon_Y_Motion;
					end
				//endcase
				
				//Update the Cannon's position with its motion
				Cannon_X_Pos_in = Cannon_X_Pos + Cannon_X_Motion;
				Cannon_Y_Pos_in = Cannon_Y_Pos + Cannon_Y_Motion;
		end
        

    end
    
    // Compute whether the pixel corresponds to Cannon or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Cannon_X_Pos;
    assign DistY = DrawY - Cannon_Y_Pos;
    assign Size = Cannon_Size;
    always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
            is_cannon = 1'b1;
        else
            is_cannon = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end
    
endmodule
