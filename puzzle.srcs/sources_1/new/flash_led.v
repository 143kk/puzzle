`timescale 1ns / 1ps
module flash_led(
 	 	input clk,
 	 	input rst,
 	 	input I_dir,
 	 	input I_clk_bps,
		input I_led_on,
 	 	output reg[7:0] O_led
 	 	);
 	 	always @( posedge clk or negedge rst )
 	 		if( (~rst) | (~I_led_on))
 	 			  O_led <= 8'b1000_0000;
 	 		else
 	 			case( I_dir )
 	 				1'b0:  			
 	 					if(I_clk_bps)
 	 				 		if( O_led != 8'd1 )
 	 							O_led <= O_led >> 1'b1;
 	 						else
 	 							O_led <= 8'b1000_0000;
 	 				1'b1:  			
 	 			 		if( I_clk_bps )
 	 						if( O_led != 8'b1000_0000)
 	 							O_led <= O_led << 1'b1;
 	 						else
 	 							O_led <= 8'b1;
 	 			endcase
endmodule

