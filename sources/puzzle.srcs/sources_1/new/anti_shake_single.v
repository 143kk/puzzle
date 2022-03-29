`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/17 22:05:02
// Design Name: 
// Module Name: anti_shake_single
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module anti_shake_single(
	input I_key,I_clk,I_rst_n,
	output O_key
    );
	wire key_changed1;
	reg [20:0] count;
//	reg [2:0] count; // for simulation
	reg t1, t_locked1, t2, t_locked2;
	
	always @(posedge I_clk or negedge I_rst_n)
		if(~I_rst_n) t1 <= 0;
		else t1 <= I_key;
		
	always @(posedge I_clk or negedge I_rst_n)
		if(~I_rst_n) t_locked1 <= 0;
		else t_locked1 <= t1;	
	
	assign key_changed1 = ~t_locked1 & t1;
	
	always @(posedge I_clk or negedge I_rst_n)
		if(~I_rst_n) count <= 0;
		else if(key_changed1) count <= 0;
		else count <= count + 1'b1;
 
	always @(posedge I_clk or negedge I_rst_n)
		if(~I_rst_n) t2 <= 0;
		else if(count == 500000)
//	 else if(count == 2) // for simulation
			t2 <= I_key;	
 
	always @(posedge I_clk or negedge I_rst_n)
		if(~I_rst_n) t_locked2 <= 0;
		else t_locked2 <= t2;	
 
	assign O_key = ~t_locked2 & t2;
 
endmodule

