module game_control(
    input [4:0] I_num,
    input I_clk,
    input I_rst_n,
    input I_btn_set, 
    input I_btn_left, 
    input I_btn_right, 
    input I_btn_up, 
    input I_btn_down,
    output reg [1:0] O_pos_a,
    output reg [1:0] O_pos_b,
    output reg [1:0] O_pos_c,
    output reg [1:0] O_pos_d,
    input I_black_EN,
    input I_rand_EN,
    output O_completed
);

wire num_valid;
wire [1:0] pos_a_native;
wire [1:0] pos_b_native;
wire [1:0] pos_c_native;
wire [1:0] pos_d_native;
wire game_start = I_black_EN;

assign O_completed = (O_pos_a == 2'b00) && (O_pos_b == 2'b01) && (O_pos_c == 2'b10) && (O_pos_d == 2'b11);

wire W_left, W_right, W_up, W_down;
wire W_left_rand, W_right_rand, W_up_rand, W_down_rand;

random_move rand_mv_inst(
    .I_clk(I_clk),
    .I_rst_n(I_rst_n),
    .I_en(I_rand_EN),
    .O_mv_left(W_left_rand),
    .O_mv_right(W_right_rand),
    .O_mv_up(W_up_rand),
    .O_mv_down(W_down_rand)
);

assign W_left = I_btn_left | W_left_rand;
assign W_right = I_btn_right | W_right_rand;
assign W_up = I_btn_up | W_up_rand;
assign W_down = I_btn_down | W_down_rand;

permutation perm_inst(
    .I_num(I_num),
    .O_pos_a(pos_a_native),
    .O_pos_b(pos_b_native),
    .O_pos_c(pos_c_native),
    .O_pos_d(pos_d_native),
    .O_num_valid(num_valid)
);

always @(posedge I_clk, negedge I_rst_n) begin
    if(~I_rst_n) begin
        O_pos_a <= 2'b00;
        O_pos_b <= 2'b01;
        O_pos_c <= 2'b10;
        O_pos_d <= 2'b11;
    end
    else if(I_btn_set) begin
        if(num_valid) begin
            O_pos_a <= pos_a_native;
            O_pos_b <= pos_b_native;
            O_pos_c <= pos_c_native;
            O_pos_d <= pos_d_native;
        end
    end
    else if(game_start) begin
        if(W_left) begin
            if(O_pos_b == 2'b10) begin
                O_pos_b <= O_pos_a;
                O_pos_a <= O_pos_b;
            end
            else if(O_pos_d == 2'b10) begin
                O_pos_d <= O_pos_c;
                O_pos_c <= O_pos_d;
            end
        end
        else if(W_right) begin
            if(O_pos_a == 2'b10) begin
                O_pos_b <= O_pos_a;
                O_pos_a <= O_pos_b;
            end
            else if(O_pos_c == 2'b10) begin
                O_pos_c <= O_pos_d;
                O_pos_d <= O_pos_c;
            end
        end
        else if(W_up) begin
            if(O_pos_c == 2'b10) begin
                O_pos_a <= O_pos_c;
                O_pos_c <= O_pos_a;
            end
            else if(O_pos_d == 2'b10) begin
                O_pos_b <= O_pos_d;
                O_pos_d <= O_pos_b;
            end
        end
        else if(W_down) begin
            if(O_pos_a == 2'b10) begin
                O_pos_c <= O_pos_a;
                O_pos_a <= O_pos_c;
            end
            else if(O_pos_b == 2'b10) begin
                O_pos_d <= O_pos_b;
                O_pos_b <= O_pos_d;
            end
        end
    end
end

endmodule