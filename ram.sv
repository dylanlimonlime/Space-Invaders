/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

 //will need one for every image

module laser_cannon ( input [18:0] read_address,
							 input Clk,
							 input [1:0] choose_cannon;

							 output logic data_Out
							 );

// mem has width of 1 bit and a total of 5922 addresses
//logic [number of bits per pixel - 1:0] mem [0:number of pixels - 1]
//number of bits per address - 1 : 0
//0 : number of addresses - 1
logic cannon [0:127];
logic cannon_hit [0:127];
logic cannon_hit2 [0:127];


initial
begin
	$readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/cannon.txt", cannon);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/cannon_hit.txt", cannon_hit);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/cannon_hit2.txt", cannon_hit2);
end


always_ff @ (posedge Clk) begin
  case(choose_cannon)
    2'b00 : data_Out<= cannon[read_address];
    2'b01 : data_Out<= cannon_hit[read_address];
    2'b10 : data_Out<= cannon_hit2[read_address];
    default : data_Out<= 5'bXXXXX;
  endcase
end

endmodule




module laser_png ( input [18:0] read_address,
						 input Clk,
						 input [2:0] choose_laser,

							 output logic data_Out
							 );

logic mem0 [0:23];
logic mem1 [0:23];
logic mem2 [0:23];
logic mem3 [0:23];
logic mem4 [0:23];
logic mem5 [0:23];


initial
begin
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/laser.txt", mem0);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/cross_laser.txt", mem1);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/wavey_laser.txt", mem2);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/wavey_laser2.txt", mem3);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/wavey_laser3.txt", mem4);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/wavey_laser4.txt", mem5);
end


always_ff @ (posedge Clk) begin
  case(choose_laser)
	3'b000 : data_Out<= mem0[read_address];
   3'b001 : data_Out<= mem1[read_address];
   3'b010 : data_Out<= mem2[read_address];
   3'b011 : data_Out<= mem3[read_address];
   3'b100 : data_Out<= mem4[read_address];
   3'b101 : data_Out<= mem5[read_address];
end

endmodule



module bunker ( input [18:0] read_address,
					 input Clk,

					 output logic data_Out
							 );

logic mem [0:383];


initial
begin
	 $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/bunker.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module enemy ( input [18:0] read_address,
							input Clk,
              input [3:0] choose_enemy,

							output logic data_Out
							);

// mem has width of 1 bit and a total of 128 addresses
logic mem0 [0:127]; //10 pts
logic mem1 [0:127];
logic mem2 [0:127]; //20 pts
logic mem3 [0:127];
logic mem4 [0:127]; //30 pts
logic mem5 [0:127];
logic hit  [0:127]; //collision
logic ufo  [0:127]; //ufo


initial
begin
	$readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/scary10pts_pos1.txt", mem0);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/scary10pts_pos2.txt", mem1);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/cute20pts_pos1.txt", mem2);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/cute20pts_pos2.txt", mem3);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/jellyfish40pts_pos1.txt", mem4);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/jellyfish40pts_pos2.txt", mem5);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/hit.txt", hit);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/ufo.txt", ufo);
end


always_ff @ (posedge Clk) begin
  case (choose_enemy)
    3'b000 : data_Out<= mem0[read_address];
    3'b001 : data_Out<= mem1[read_address];
    3'b010 : data_Out<= mem2[read_address];
    3'b011 : data_Out<= mem3[read_address];
    3'b100 : data_Out<= mem4[read_address];
    3'b101 : data_Out<= mem5[read_address];
    3'b110 : data_Out<= hit[read_address];
    3'b111 : data_Out<= ufo[read_address];
    default : data_Out<= 1'bX; //might need to change bit length
  endcase
end

endmodule




module alphabet ( input [18:0] read_address,
							input Clk,
              input [4:0] choose_letter,

							output logic data_Out
							);

// mem has width of 1 bit and a total of 64 addresses
logic mem1 [0:63];
logic mem2 [0:63];
logic mem3 [0:63];
logic mem4 [0:63];
logic mem5 [0:63];
logic mem6 [0:63];
logic mem7 [0:63];
logic mem8 [0:63];
logic mem9 [0:63];
logic mem10 [0:63];
logic mem11 [0:63];
logic mem12 [0:63];
logic mem13 [0:63];
logic mem14 [0:63];
logic mem15 [0:63];
logic mem16 [0:63];
logic mem17 [0:63];
logic mem18 [0:63];
logic mem19 [0:63];
logic mem20 [0:63];
logic mem21 [0:63];
logic mem22 [0:63];
logic mem23 [0:63];
logic mem24 [0:63];
logic mem25 [0:63];
logic mem26 [0:63];


initial
begin
	$readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_a.txt", mem1);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_b.txt", mem2);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_c.txt", mem3);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_d.txt", mem4);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_e.txt", mem5);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_f.txt", mem6);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_g.txt", mem7);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_h.txt", mem8);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_i.txt", mem9);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_j.txt", mem10);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_k.txt", mem11);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_l.txt", mem12);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_m.txt", mem13);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_n.txt", mem14);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_o.txt", mem15);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_p.txt", mem16);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_q.txt", mem17);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_r.txt", mem18);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_s.txt", mem19);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_t.txt", mem20);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_u.txt", mem21);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_v.txt", mem22);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_w.txt", mem23);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_x.txt", mem24);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_y.txt", mem25);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/letter_z.txt", mem26);
end


always_ff @ (posedge Clk) begin
  case (choose_letter)
    5'b00001 : data_Out<= mem1[read_address];
    5'b00010 : data_Out<= mem2[read_address];
    5'b00011 : data_Out<= mem3[read_address];
    5'b00100 : data_Out<= mem4[read_address];
    5'b00101 : data_Out<= mem5[read_address];
    5'b00110 : data_Out<= mem6[read_address];
    5'b00111 : data_Out<= mem7[read_address];
    5'b01000 : data_Out<= mem8[read_address];
    5'b01001 : data_Out<= mem9[read_address];
    5'b01010 : data_Out<= mem10[read_address];
    5'b01011 : data_Out<= mem11[read_address];
    5'b01100 : data_Out<= mem12[read_address];
    5'b01101 : data_Out<= mem13[read_address];
    5'b01110 : data_Out<= mem14[read_address];
    5'b01111 : data_Out<= mem15[read_address];
    5'b10000 : data_Out<= mem16[read_address];
    5'b10001 : data_Out<= mem17[read_address];
    5'b10010 : data_Out<= mem18[read_address];
    5'b10011 : data_Out<= mem19[read_address];
    5'b10100 : data_Out<= mem20[read_address];
    5'b10101 : data_Out<= mem21[read_address];
    5'b10110 : data_Out<= mem22[read_address];
    5'b10111 : data_Out<= mem23[read_address];
    5'b11000 : data_Out<= mem24[read_address];
    5'b11001 : data_Out<= mem25[read_address];
    5'b11010 : data_Out<= mem26[read_address];
    5'b11011 : data_Out<= equal[read_address];
    5'b11100 : data_Out<= hyphen[read_address];
    default : data_Out<= 1'bX;
  endcase
end

endmodule




module punctuation ( input [18:0] read_address,
							       input Clk,
                     input [2:0] choose_punct,

							       output logic data_Out
							       );

// mem has width of 1 bit and a total of 128 addresses
logic equal [0:63];
logic hyphen [0:63];
logic left [0:63];
logic right [0:63];
logic multiply [0:63];
logic question [0:63];


initial
begin
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/equal_sign.txt", equal);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/hyphen.txt", hyphen);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/left_arrow.txt", left);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/right_arrow.txt", right);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/multiply_sign.txt", multiply);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/question_mark.txt", question);
end


always_ff @ (posedge Clk) begin
  case (choose_punct)
    3'b000 : data_Out<= equal[read_address];
    3'b001 : data_Out<= hyphen[read_address];
    3'b010 : data_Out<= left[read_address];
    3'b011 : data_Out<= right[read_address];
    3'b100 : data_Out<= multiply[read_address];
    3'b101 : data_Out<= question[read_address];
    default : data_Out<= 1'bX; //might need to change bit length
  endcase
end

endmodule




module numbers ( input [18:0] read_address,
							input Clk,
              input [3:0] choose_number,

							output logic data_Out
							);

// mem has width of 1 bit and a total of 128 addresses
logic mem0 [0:63];
logic mem1 [0:63];
logic mem2 [0:63];
logic mem3 [0:63];
logic mem4 [0:63];
logic mem5 [0:63];
logic mem6 [0:63];
logic mem7 [0:63];
logic mem8 [0:63];
logic mem9 [0:63];


initial
begin
	 $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/num_0.txt", mem0);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/num_1.txt", mem1);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/num_2.txt", mem2);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/num_3.txt", mem3);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/num_4.txt", mem4);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/num_5.txt", mem5);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/num_6.txt", mem6);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/num_7.txt", mem7);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/num_8.txt", mem8);
   $readmemh("U:/ece385_final/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/num_9.txt", mem9);
end


always_ff @ (posedge Clk) begin
  case (choose_number)
    4'b0000 : data_Out<= mem0[read_address];
    4'b0001 : data_Out<= mem1[read_address];
    4'b0010 : data_Out<= mem2[read_address];
    4'b0011 : data_Out<= mem3[read_address];
    4'b0100 : data_Out<= mem4[read_address];
    4'b0101 : data_Out<= mem5[read_address];
    4'b0110 : data_Out<= mem6[read_address];
    4'b0111 : data_Out<= mem7[read_address];
    4'b1000 : data_Out<= mem8[read_address];
    4'b1001 : data_Out<= mem9[read_address];
    default : data_Out<= 1'bX; //might need to change bit length
  endcase
end

endmodule
