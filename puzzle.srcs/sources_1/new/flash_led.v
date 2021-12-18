`timescale 1ns / 1ps
module flash_led(
 	 	input clk,
 	 	input rst,
 	 	input I_dir,
 	 	input I_clk_bps,
		input I_led_on,
 	 	output reg[15:0] O_led
 	 	);
 	 	always @( posedge clk or negedge rst )
 	 		if( (~rst) | (~I_led_on))
 	 			  O_led <= 16'h8000;
 	 		else
 	 			case( I_dir )
 	 				1'b0:  			
 	 					if(I_clk_bps)
 	 				 		if( O_led != 16'd1 )
 	 							O_led <= O_led >> 1'b1;
 	 						else
 	 							O_led <= 16'h8000;
 	 				1'b1:  			
 	 			 		if( I_clk_bps )
 	 						if( O_led != 16'h8000 )
 	 							O_led <= O_led << 1'b1;
 	 						else
 	 							O_led <= 16'd1;
 	 			endcase
endmodule

