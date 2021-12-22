`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/17 15:03:38
// Design Name: 
// Module Name: step_counter
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

module step_counter(
input clk,
input rst,
input wire switch,
input wire set,
input wire step,
output reg [7:0] num, 
output reg [3:0] seg_en
);

parameter    SEG_NUM0 = 8'b1100_0000,  
              SEG_NUM1 = 8'b1111_1001,
			  SEG_NUM2 = 8'b1010_0100,
			  SEG_NUM3 = 8'b1011_0000,
			  SEG_NUM4 = 8'b1001_1001,
			  SEG_NUM5 = 8'b1001_0010,
			  SEG_NUM6 = 8'b1000_0010,
			  SEG_NUM7 = 8'b1111_1000,
			  SEG_NUM8 = 8'b1000_0000,
			  SEG_NUM9 = 8'b1001_0000;
			  
parameter    DUAN_3 = 4'b0111,			  
			  DUAN_2 = 4'b1011,
			  DUAN_1 = 4'b1101,
			  DUAN_0 = 4'b1110;

reg [20:0] count;
reg cen = 0;
integer state = 1;

reg [3:0] one;
reg [3:0] two;
reg [3:0] three;
reg [3:0] four;

always @ (posedge clk) begin
   count <= count + 1'b1;	
end

always @ (posedge clk or negedge rst) begin
if (~rst) begin
state <= 1;
cen <= 0;
end
else if (set) begin
state <= 1;
cen <= 0;
end
else begin
 case(state)
    0: begin   
	    cen <= 1;
	    if(!switch)
		 state <= 1;
		 else	
		  state <= 0;
	    end
	 1: begin 
	    cen <= 0;
	    if(switch) 
		 state <= 0;
		 else
		 state <= 1;
       end		 
 endcase
    end
end

always @ (posedge clk or negedge rst) begin 
if(~rst)begin
one <= 0;
two <= 0;
three <= 0;
four <= 0;
end
else if(set)begin
one <= 0;
two <= 0;
three <= 0;
four <= 0;
end
else begin
if(cen) begin
    if(step) begin
     case(one)
	 4'b1001: one <= 4'b0000;
	 default:  one <= one + 1'b1;
	 endcase 
	 case(two)
	 4'b1001: begin
	           if(one == 4'b1001)
	             two <= 4'b0000;
				 end
	 default: begin
    	       if(one == 4'b1001)
	             two <= two + 1'b1;
				 end
	 endcase
	 case(three)
	 4'b1001: begin
	           if(one == 4'b1001 && two == 4'b1001)
	             three <= 4'b0000;
				 end
	 default: begin
    	       if(one == 4'b1001 && two == 4'b1001)
	             three <= three + 1'b1;
				 end
	 endcase
	 case(four)
	 4'b1001: begin
	           if(one == 4'b1001 && two == 4'b1001 && three == 4'b1001)
	             four <= 4'b0000;
				 end
	 default: begin
    	       if(one == 4'b1001 && two == 4'b1001 && three == 4'b1001)
	             four <= four + 1'b1;
				 end
	 endcase
            end
        end
    end
end

 
always @ (posedge clk) begin
  case(count[19:18])
  2'b00: begin
          seg_en <= DUAN_3;
			 case(four)
			 4'b0000: num <= SEG_NUM0;
             4'b0001: num <= SEG_NUM1;
             4'b0010: num <= SEG_NUM2;
             4'b0011: num <= SEG_NUM3;
             4'b0100: num <= SEG_NUM4;
             4'b0101: num <= SEG_NUM5;
             4'b0110: num <= SEG_NUM6;
             4'b0111: num <= SEG_NUM7;
             4'b1000: num <= SEG_NUM8;
             4'b1001: num <= SEG_NUM9;
			 endcase
			end
	
  2'b01: begin
          seg_en <= DUAN_2;
			 case(three)
			 4'b0000: num <= SEG_NUM0;
			 4'b0001: num <= SEG_NUM1;
			 4'b0010: num <= SEG_NUM2;
			 4'b0011: num <= SEG_NUM3;
			 4'b0100: num <= SEG_NUM4;
			 4'b0101: num <= SEG_NUM5;
			 4'b0110: num <= SEG_NUM6;
			 4'b0111: num <= SEG_NUM7;
			 4'b1000: num <= SEG_NUM8;
			 4'b1001: num <= SEG_NUM9;
			 endcase
			end
  2'b10: begin
          seg_en <= DUAN_1;
			 case(two)
			 4'b0000: num <= SEG_NUM0;
             4'b0001: num <= SEG_NUM1;
             4'b0010: num <= SEG_NUM2;
             4'b0011: num <= SEG_NUM3;
             4'b0100: num <= SEG_NUM4;
             4'b0101: num <= SEG_NUM5;
             4'b0110: num <= SEG_NUM6;
             4'b0111: num <= SEG_NUM7;
             4'b1000: num <= SEG_NUM8;
             4'b1001: num <= SEG_NUM9;
			 endcase
			end
  2'b11: begin
          seg_en <= DUAN_0;
			 case(one)
			 4'b0000: num <= SEG_NUM0;
			 4'b0001: num <= SEG_NUM1;
			 4'b0010: num <= SEG_NUM2;
			 4'b0011: num <= SEG_NUM3;
			 4'b0100: num <= SEG_NUM4;
			 4'b0101: num <= SEG_NUM5;
			 4'b0110: num <= SEG_NUM6;
			 4'b0111: num <= SEG_NUM7;
			 4'b1000: num <= SEG_NUM8;
			 4'b1001: num <= SEG_NUM9;
			 endcase
			end
  endcase
 
end

endmodule

