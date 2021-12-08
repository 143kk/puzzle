`timescale 1ns / 1ps



module tb_vga();

reg clk;
reg reset;

initial begin
    clk = 0;
    reset = 0;
    #1 reset = 1;
    forever #3 clk = ~clk;
end

wire [3:0] red;
wire [3:0] green;
wire [3:0] blue;
wire hs, vs;

reg [7:0] pixel_data;
wire [9:0] pixel_x;
wire [9:0] pixel_y;
wire pixel_valid;

vga vga_inst(
    .I_clk_25M(clk),
    .I_rst_n(reset),
    .O_red(red),
    .O_green(green),
    .O_blue(blue),
    .O_hs(hs),
    .O_vs(vs),
    .I_pixel_data(pixel_data),
    .O_pixel_x(pixel_x),
    .O_pixel_y(pixel_y),
    .O_pixel_valid(pixel_valid)
);

initial begin
    pixel_data = 8'b11111111;
    #10000000 $finish();
end

endmodule
