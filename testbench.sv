module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic CLOCK_50 = 0;
logic Reset;
logic [3:0] KEY;
logic [6:0] HEX0, HEX1;

logic [7:0]  VGA_R, VGA_G, VGA_B;
logic        VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS;      //VGA horizontal sync signal
wire  [15:0] OTG_DATA;     //CY7C67200 Data bus 16 Bits
logic [1:0]  OTG_ADDR;     //CY7C67200 Address 2 Bits
logic        OTG_CS_N, OTG_RD_N, OTG_WR_N, OTG_RST_N,  OTG_INT;      //CY7C67200 Interrupt
logic [12:0] DRAM_ADDR;    //SDRAM Address 13 Bits
wire  [31:0] DRAM_DQ;      //SDRAM Data 32 Bits
logic [1:0]  DRAM_BA;      //SDRAM Bank Address 2 Bits
logic [3:0]  DRAM_DQM;     //SDRAM Data Mast 4 Bits
logic        DRAM_RAS_N, DRAM_CAS_N, DRAM_CKE, DRAM_WE_N, DRAM_CS_N, DRAM_CLK;


logic [9:0] Cannon_X_Pos, Cannon_X_Motion, Cannon_Y_Pos, Cannon_Y_Motion;
logic [9:0] Cannon_X_Pos_in, Cannon_X_Motion_in, Cannon_Y_Pos_in, Cannon_Y_Motion_in;
logic [7:0] keycode;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
final_project final_project0(.*);	

assign keycode = final_project0.keycode;
assign Cannon_X_Pos = final_project0.lc_instance.Cannon_X_Pos;
assign Cannon_X_Motion = final_project0.lc_instance.Cannon_X_Motion;
assign Cannon_Y_Pos = final_project0.lc_instance.Cannon_Y_Pos;
assign Cannon_Y_Motion = final_project0.lc_instance.Cannon_Y_Motion;
assign Cannon_X_Pos_in = final_project0.lc_instance.Cannon_X_Pos_in;
assign Cannon_X_Motion_in = final_project0.lc_instance.Cannon_X_Motion_in;  
assign Cannon_Y_Pos_in = final_project0.lc_instance.Cannon_Y_Pos_in;  
assign Cannon_Y_Motion_in = final_project0.lc_instance.Cannon_Y_Motion_in;  


// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 CLOCK_50 = ~CLOCK_50;
end

initial begin: CLOCK_INITIALIZATION
    CLOCK_50 = 0;
end 


//internal monitoring
//logic [15:0] IR, PC, MAR, MDR;
//logic [15:0] ALU_out;                                              
//assign IR = lab6_toplevel0. ;
//assign ALU_out = 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program


//for simulation, need to show 3 instructions from 
//ADD/ADDi/AND/ANDi/NOT
//BR/JMP/JSR
//LDR/STR
initial begin: TEST_VECTORS
Reset = 1;		// reset system

#2 Reset = 0;
#2 Reset = 1;

#10 keycode = 8'h4f;

#10 keycode = 8'h50;



end
endmodule
