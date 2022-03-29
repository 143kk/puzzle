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

    output O_completed,
    input I_rand_move_EN,
    input I_rand_set_EN,
    input I_hard_mode,

    // ljy
    output [3:0] O_seg_en_time,
    output [3:0] O_seg_en_step,
    output [7:0] O_num,

    // myc
    input I_unsolvable,
    input I_music_on,
    output wire O_music, 
    output wire [15:0] O_led
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

    wire [3:0] pos_a;
    wire [3:0] pos_b;
    wire [3:0] pos_c;
    wire [3:0] pos_d;
    wire [3:0] pos_e;
    wire [3:0] pos_f;
    wire [3:0] pos_g;
    wire [3:0] pos_h;  
    wire [3:0] pos_i;

    //reg [4:0] num;

    wire W_btn_left;
    wire W_btn_right;
    wire W_btn_up;
    wire W_btn_down;


    // 生成25MHz的clk
    clk_25m clk_25m(.resetn(I_rst_n), .clk_in1(I_clk_100M), .clk_out1(W_clk_25M));

    wire W_hasSolution;

    check check_inst(
        .IA(pos_a),
        .IB(pos_b),
        .IC(pos_c),
        .ID(pos_d),
        .I_clk(I_clk_100M),
        .I_rst_n(I_rst_n),
        .hard(I_hard_mode),
        .I_black_EN(I_black_EN),
        .O_hasSolution(W_hasSolution)
    );

    music_led_top ml_top_inst(
        .I_clk(I_clk_100M),
        .I_rst_n(I_rst_n),
        .I_black_EN(I_black_EN),
        .I_completed(O_completed),
        .I_unsolvable(~W_hasSolution),
        .I_music_on(I_music_on),
        .O_music(O_music),
        .O_led(O_led)
    );

    wire W_moving;

    second_counter step_cnt_inst(
        .clk(I_clk_100M),
        .switch(I_black_EN),
        .set(I_btn_set),
        .rst(I_rst_n),
        .num(O_num),
        .seg_en(O_seg_en_time)
    );

    // counter_ss cnt_inst(
    //     .clk(I_clk_100M), 
    //     .switch(I_black_EN),
    //     .set(I_btn_set),
    //     .rst(I_rst_n),
    //     .num(O_num),
    //     .seg_en_time(O_seg_en_time),
    //     .seg_en_step(O_seg_en_step),
    //     .step(O_moving)
    // );

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

    anti_shake_single ass_left(
        .I_key(I_btn_left),
        .I_rst_n(I_rst_n),
        .I_clk(W_clk_25M),
        .O_key(W_btn_left)
    );

    anti_shake_single ass_right(
        .I_key(I_btn_right),
        .I_rst_n(I_rst_n),
        .I_clk(W_clk_25M),
        .O_key(W_btn_right)
    );

    anti_shake_single ass_up(
        .I_key(I_btn_up),
        .I_rst_n(I_rst_n),
        .I_clk(W_clk_25M),
        .O_key(W_btn_up)
    );

    anti_shake_single ass_down(
        .I_key(I_btn_down),
        .I_rst_n(I_rst_n),
        .I_clk(W_clk_25M),
        .O_key(W_btn_down)
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
        .I_pos_e(pos_e),
        .I_pos_f(pos_f),
        .I_pos_g(pos_g),
        .I_pos_h(pos_h),
        .I_pos_i(pos_i),

        .O_read_addr(read_addr),
        .I_rst_n(I_rst_n),
        .I_clk_25M(W_clk_25M),
        .I_hard_mode(I_hard_mode)
    );

    game_control gamectrl_inst(
        .I_num(I_num),
        .I_rst_n(I_rst_n),
        .O_pos_a(pos_a),
        .O_pos_b(pos_b),
        .O_pos_c(pos_c),
        .O_pos_d(pos_d),
        .O_pos_e(pos_e),
        .O_pos_f(pos_f),
        .O_pos_g(pos_g),
        .O_pos_h(pos_h),
        .O_pos_i(pos_i),

        .O_completed(O_completed),
        
        .I_btn_set(I_btn_set), 
        .I_btn_left(W_btn_left), 
        .I_btn_right(W_btn_right), 
        .I_btn_up(W_btn_up), 
        .I_btn_down(W_btn_down),
        .I_black_EN(I_black_EN),
        .I_clk(W_clk_25M),
        .I_rand_move_EN(I_rand_move_EN),
        .I_rand_set_EN(I_rand_set_EN),
        .I_hard_mode(I_hard_mode),
        .O_moving(W_moving)
    );

    img_mem_ctrl imc_inst(
        .I_clk_25M(W_clk_25M),
        .I_rst_n(I_rst_n),
        .I_write_en(W_rx_data_ready),
        .I_write_data(W_rx_data),
        .O_pixel_data(W_pixel_data),
        .I_read_addr(read_addr)
    );
endmodule
