module top(
    input I_clk_100M,
    input I_rst_n,
    input I_uart_rx,
    input I_black_EN,
    input [4:0] I_num,
    output O_uart_tx,
    output O_transmitting,
    output [3:0] O_red,
    output [3:0] O_green,
    output [3:0] O_blue,
    output O_hs,
    output O_vs,

    input I_btn_set, 
    input I_btn_left, 
    input I_btn_right, 
    input I_btn_up, 
    input I_btn_down,

    output O_completed
);
    wire W_clk_25M;
    wire [17:0] read_addr;
    wire W_rx_data_ready;
    wire [7:0] W_rx_data;
    wire W_rx_idle;
    assign O_transmitting = ~W_rx_idle;

    wire [7:0] W_pixel_data;
    wire [9:0] W_pixel_x;
    wire [9:0] W_pixel_y;
    wire W_pixel_valid;
    wire [11:0] pixel_data_rgb444;

    wire [1:0] pos_a;
    wire [1:0] pos_b;
    wire [1:0] pos_c;
    wire [1:0] pos_d;

    reg [4:0] num;

    // 生成25MHz的clk
    clk_25m clk_25m(.resetn(I_rst_n), .clk_in1(I_clk_100M), .clk_out1(W_clk_25M));

    async_receiver rx_inst(
        .clk(W_clk_25M), 
        .RxD(I_uart_rx), 
        .RxD_data_ready(W_rx_data_ready), 
        .RxD_data(W_rx_data),
        .RxD_idle(W_rx_idle)
    );

    vga vga_inst(
        .I_clk_25M(W_clk_25M),
        .I_rst_n(I_rst_n),
        .O_red(O_red),
        .O_green(O_green),
        .O_blue(O_blue),
        .O_hs(O_hs),
        .O_vs(O_vs),
        .I_pixel_data(pixel_data_rgb444),
        .O_pixel_x(W_pixel_x),
        .O_pixel_y(W_pixel_y),
        .O_pixel_valid(W_pixel_valid)
    );

    pixel_ctrl pctrl_inst(
        .I_pixel_x(W_pixel_x),
        .I_pixel_y(W_pixel_y),
        .I_pixel_data(W_pixel_data),
        .I_black_EN(I_black_EN),
        .O_pixel_data(pixel_data_rgb444),

        .I_pos_a(pos_a),
        .I_pos_b(pos_b),
        .I_pos_c(pos_c),
        .I_pos_d(pos_d),
        .O_read_addr(read_addr)
    );

    game_control gamectrl_inst(
        .I_num(I_num),
        .I_rst_n(I_rst_n),
        .O_pos_a(pos_a),
        .O_pos_b(pos_b),
        .O_pos_c(pos_c),
        .O_pos_d(pos_d),
        .O_completed(O_completed),
        .O_num(num),
        
        .I_btn_set(I_btn_set), 
        .I_btn_left(I_btn_left), 
        .I_btn_right(I_btn_right), 
        .I_btn_up(I_btn_up), 
        .I_btn_down(I_btn_down),
        .I_black_EN(I_black_EN),
        .I_clk(W_clk_25M)
    );

    img_mem_ctrl imc_inst(
        .I_clk_25M(W_clk_25M),
        .I_rst_n(I_rst_n),
        .I_write_en(W_rx_data_ready),
        .I_write_data(W_rx_data),
        .I_read_en(W_pixel_valid),
        .O_pixel_data(W_pixel_data),
        .I_read_addr(read_addr)
    );
endmodule
