//-------------------------------------------------------------------------
//      final_project.sv                                                    
//-------------------------------------------------------------------------


module final_project( input               CLOCK_50,
							 input        [3:0]  KEY,          //bit 0 is set up as Reset
							 output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							 // VGA Interface 
							 output logic [7:0]  VGA_R,        //VGA Red
														VGA_G,        //VGA Green
														VGA_B,        //VGA Blue
							 output logic        VGA_CLK,      //VGA Clock
														VGA_SYNC_N,   //VGA Sync signal
														VGA_BLANK_N,  //VGA Blank signal
														VGA_VS,       //VGA virtical sync signal
														VGA_HS,       //VGA horizontal sync signal
							 // CY7C67200 Interface
							 inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
							 output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
							 output logic        OTG_CS_N,     //CY7C67200 Chip Select
														OTG_RD_N,     //CY7C67200 Write
														OTG_WR_N,     //CY7C67200 Read
														OTG_RST_N,    //CY7C67200 Reset
							 input               OTG_INT,      //CY7C67200 Interrupt
							 // SDRAM Interface for Nios II Software
							 output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
							 inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
							 output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
							 output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
							 output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
														DRAM_CAS_N,   //SDRAM Column Address Strobe
														DRAM_CKE,     //SDRAM Clock Enable
														DRAM_WE_N,    //SDRAM Write Enable
														DRAM_CS_N,    //SDRAM Chip Select
														DRAM_CLK      //SDRAM Clock
									  );
			 
	 logic Reset_h, Clk;
    logic [15:0] keycode;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 
	 logic is_cannon, is_laser;
	 logic [9:0] Cannon_X_Pos_in;
	 logic [9:0] x_pos, y_pos;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
	  always_ff @ (posedge Clk) begin
		if(Reset_h)
			VGA_CLK <= 1'b0;
		else
			VGA_CLK <= ~VGA_CLK;
	end
    // You will have to generate it on your own in simulation.
    //vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk(Clk),
                                           .Reset(Reset_h),
														 .VGA_HS(VGA_HS),      // Horizontal sync pulse.  Active low
														 .VGA_VS(VGA_VS),      // Vertical sync pulse.  Active low
														 .VGA_CLK(VGA_CLK),     // 25 MHz VGA clock input
														 .VGA_BLANK_N(VGA_BLANK_N), // Blanking interval indicator.  Active low.
                                           .VGA_SYNC_N(VGA_SYNC_N),  // Composite Sync signal.  Active low.  We don't use it in this lab,
														 .DrawX(x_pos),      
                                           .DrawY(y_pos)        
														 );
    
    // Which signal should be frame_clk?
    cannon cannon_instance(.Clk(Clk),       
									  .Reset(Reset_h),              
									  .frame_clk(VGA_VS),
								 	  .DrawX(x_pos), 
								     .DrawY(y_pos),
									  .left(left),
									  .right(right),
									  .is_cannon(is_cannon),
									  .Cannon_X_Pos_in(Cannon_X_Pos_in)
									  );
									  
	 laser laser_instance(.Clk(Clk),
								 .Reset(Reset_h), 
								 .frame_clk(VGA_VS),
								 .DrawX(x_pos), 
								 .DrawY(y_pos),
								 .keycode1(space),
								 .Cannon_X_Pos_in(Cannon_X_Pos_in), 
								 .is_laser(is_laser),
								 );
    
    color_mapper color_instance(.is_cannon(is_cannon),
										  .is_laser(is_laser),
										  .DrawX(x_pos),
										  .DrawY(y_pos),
										  .VGA_R(VGA_R), 
										  .VGA_G(VGA_G), 
										  .VGA_B(VGA_B)
										  ); 
	 
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
    HexDriver hex_inst_2 (keycode[11:8], HEX2);
    HexDriver hex_inst_3 (keycode[15:11], HEX3);
	 
	 HexDriver hex_inst_4 (space[3:0], HEX4);
	 HexDriver hex_inst_5 (space[7:4], HEX5);
	 HexDriver hex_inst_6 (right[3:0], HEX6);
	 HexDriver hex_inst_7 (left[3:0], HEX7);
	 
	 logic [7:0] space, left, right;
	 
	 assign space = (keycode[15:8]==8'h2c | keycode[7:0]==8'h2c);
	 assign left = (keycode[15:8]==8'h50 | keycode[7:0]==8'h50);
	 assign right = (keycode[15:8]==8'h4f | keycode[7:0]==8'h4f);

endmodule
