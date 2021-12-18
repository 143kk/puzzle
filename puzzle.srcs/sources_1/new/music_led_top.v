`timescale 1ns / 1ps
module music_led_top(
    input I_clk,
    input I_rst_n,
    input I_black_EN,
    input I_completed,
    input I_unsolvable,
    input I_music_on,
    output wire  O_music, 
    output wire [15:0] O_led 
);

wire clk_bps;
wire dir;
wire led_on;
wire [4:0] mode;

led_music_control l(
    .I_clk(I_clk),
    .I_rst_n(I_rst_n),
    .I_black_EN(I_black_EN),
    .I_completed(I_completed),
    .I_unsolvable(I_unsolvable),
    .I_music_on(I_music_on),
    .O_led_on(led_on), 
    .O_dir(dir),
    .mode(mode) 
);

counter counter(
 	.clk(I_clk),
 	.rst(I_rst_n),
 	.clk_bps(clk_bps)
);

flash_led f(
    .clk(I_clk),
    .rst(I_rst_n),
    .I_dir(dir),
 	.I_clk_bps(clk_bps),
    .I_led_on(led_on),
 	.O_led(O_led)
);

Music m(
    .clk(I_clk),
    .mode(mode),
    .music(O_music)
);


endmodule