module game_control(
    input [4:0] I_num,
    input I_clk,
    input I_rst_n,
    input I_btn_set, 
    input I_btn_left, 
    input I_btn_right, 
    input I_btn_up, 
    input I_btn_down,
    output reg [3:0] O_pos_a,
    output reg [3:0] O_pos_b,
    output reg [3:0] O_pos_c,
    output reg [3:0] O_pos_d,
    output reg [3:0] O_pos_e,
    output reg [3:0] O_pos_f,
    output reg [3:0] O_pos_g,
    output reg [3:0] O_pos_h,  
    output reg [3:0] O_pos_i,
    input I_black_EN,
    input I_rand_move_EN,
    input I_rand_set_EN,
    input I_hard_mode,
    output O_completed,
    output reg O_moving
);

wire num_valid;
wire [1:0] pos_a_native;
wire [1:0] pos_b_native;
wire [1:0] pos_c_native;
wire [1:0] pos_d_native;
wire [1:0] pos_a_rand;
wire [1:0] pos_b_rand;
wire [1:0] pos_c_rand;
wire [1:0] pos_d_rand;
wire game_start = I_black_EN;

assign O_completed = I_hard_mode 
    ? ((O_pos_a == 4'b0000) && (O_pos_b == 4'b0001) && (O_pos_c == 4'b0010) && (O_pos_d == 4'b0100) && (O_pos_e == 4'b0101) && (O_pos_f == 4'b0110) && (O_pos_g == 4'b1000) && (O_pos_h == 4'b1001) && (O_pos_h == 4'b1010))
    : ((O_pos_a[1:0] == 2'b00) && (O_pos_b[1:0] == 2'b01) && (O_pos_c[1:0] == 2'b10) && (O_pos_d[1:0] == 2'b11));

wire W_left, W_right, W_up, W_down;
wire W_left_rand, W_right_rand, W_up_rand, W_down_rand;

random_move rand_mv_inst(
    .I_clk(I_clk),
    .I_rst_n(I_rst_n),
    .I_en(I_rand_move_EN),
    .O_mv_left(W_left_rand),
    .O_mv_right(W_right_rand),
    .O_mv_up(W_up_rand),
    .O_mv_down(W_down_rand)
);

rand_pos rand_pos_inst(
    .I_clk(I_clk),
    .O_pos_a(pos_a_rand),
    .O_pos_b(pos_b_rand),
    .O_pos_c(pos_c_rand),
    .O_pos_d(pos_d_rand)
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
        O_moving <= 0;
        if(I_hard_mode) begin
            O_pos_a <= 4'b0000;
            O_pos_b <= 4'b0001;
            O_pos_c <= 4'b0010;

            O_pos_d <= 4'b0100;
            O_pos_e <= 4'b0101;
            O_pos_f <= 4'b0110;

            O_pos_g <= 4'b1000;
            O_pos_h <= 4'b1001;
            O_pos_i <= 4'b1010;   
        end
        else begin
            O_pos_a <= 4'b0000;
            O_pos_b <= 4'b0001;
            O_pos_c <= 4'b0010;
            O_pos_d <= 4'b0011;
        end
    end
    else if(I_btn_set) begin
        O_moving <= 0;
        if(I_hard_mode) begin
            O_pos_a <= 4'b0000;
            O_pos_b <= 4'b0001;
            O_pos_c <= 4'b0010;

            O_pos_d <= 4'b0100;
            O_pos_e <= 4'b0101;
            O_pos_f <= 4'b0110;

            O_pos_g <= 4'b1000;
            O_pos_h <= 4'b1001;
            O_pos_i <= 4'b1010;   
        end
        else if(I_rand_set_EN) begin
            O_pos_a <= pos_a_rand;
            O_pos_b <= pos_b_rand;
            O_pos_c <= pos_c_rand;
            O_pos_d <= pos_d_rand;
        end
        else if(num_valid) begin
            O_pos_a <= pos_a_native;
            O_pos_b <= pos_b_native;
            O_pos_c <= pos_c_native;
            O_pos_d <= pos_d_native;
        end
    end
    else if(game_start) begin
        if(I_hard_mode) begin
            casex ({W_left, W_right, W_up, W_down})
            4'b1xxx: begin
                if(O_pos_i == 4'b1000) begin
                    O_pos_h <= O_pos_i;
                    O_pos_i <= O_pos_h;
                    O_moving <= 1;
                end
                else if(O_pos_h == 4'b1000) begin
                    O_pos_g <= O_pos_h;
                    O_pos_h <= O_pos_g;
                    O_moving <= 1;
                end 
                else if(O_pos_f == 4'b1000) begin
                    O_pos_f <= O_pos_e;
                    O_pos_e <= O_pos_f;
                    O_moving <= 1;
                end
                else if(O_pos_e == 4'b1000) begin
                    O_pos_e <= O_pos_d;
                    O_pos_d <= O_pos_e;
                    O_moving <= 1;
                end
                else if(O_pos_c == 4'b1000) begin
                    O_pos_c <= O_pos_b;
                    O_pos_b <= O_pos_c;
                    O_moving <= 1;
                end 
                else if(O_pos_b == 4'b1000) begin
                    O_pos_b <= O_pos_a;
                    O_pos_a <= O_pos_b;
                    O_moving <= 1;
                end 
                else O_moving <= 0;
            end
            4'b01xx: begin
                if(O_pos_a == 4'b1000) begin
                    O_pos_b <= O_pos_a;
                    O_pos_a <= O_pos_b;
                    O_moving <= 1;
                end
                else if(O_pos_b == 4'b1000) begin
                    O_pos_c <= O_pos_b;
                    O_pos_b <= O_pos_c;
                    O_moving <= 1;
                end
                else if(O_pos_d == 4'b1000) begin
                    O_pos_d <= O_pos_e;
                    O_pos_e <= O_pos_d;
                    O_moving <= 1;
                end
                else if(O_pos_e == 4'b1000) begin
                    O_pos_e <= O_pos_f;
                    O_pos_f <= O_pos_e;
                    O_moving <= 1;
                end
                else if(O_pos_g == 4'b1000) begin
                    O_pos_g <= O_pos_h;
                    O_pos_h <= O_pos_g;
                    O_moving <= 1;
                end
                else if(O_pos_h == 4'b1000) begin
                    O_pos_i <= O_pos_h;
                    O_pos_h <= O_pos_i;
                    O_moving <= 1;
                end
                else O_moving <= 0;
            end
            4'b001x: begin
                if(O_pos_d == 4'b1000) begin
                    O_pos_a <= O_pos_d;
                    O_pos_d <= O_pos_a;
                    O_moving <= 1;
                end
                else if(O_pos_e == 4'b1000) begin
                    O_pos_e <= O_pos_b;
                    O_pos_b <= O_pos_e;
                    O_moving <= 1;
                end
                else if(O_pos_f == 4'b1000) begin
                    O_pos_f <= O_pos_c;
                    O_pos_c <= O_pos_f;
                    O_moving <= 1;
                end
                else if(O_pos_g == 4'b1000) begin
                    O_pos_g <= O_pos_d;
                    O_pos_d <= O_pos_g;
                    O_moving <= 1;
                end
                else if(O_pos_h == 4'b1000) begin
                    O_pos_h <= O_pos_e;
                    O_pos_e <= O_pos_h;
                    O_moving <= 1;
                end
                else if(O_pos_i == 4'b1000) begin
                    O_pos_i <= O_pos_f;
                    O_pos_f <= O_pos_i;
                    O_moving <= 1;
                end
                else O_moving <= 0;
            end
            4'b0001: begin
                if(O_pos_a == 4'b1000) begin
                    O_pos_a <= O_pos_d;
                    O_pos_d <= O_pos_a;
                    O_moving <= 1;
                end
                else if(O_pos_b == 4'b1000) begin
                    O_pos_b <= O_pos_e;
                    O_pos_e <= O_pos_b;
                    O_moving <= 1;
                end
                else if(O_pos_c == 4'b1000) begin
                    O_pos_c <= O_pos_f;
                    O_pos_f <= O_pos_c;
                    O_moving <= 1;
                end
                else if(O_pos_d == 4'b1000) begin
                    O_pos_d <= O_pos_g;
                    O_pos_g <= O_pos_d;
                    O_moving <= 1;
                end
                else if(O_pos_e == 4'b1000) begin
                    O_pos_h <= O_pos_e;
                    O_pos_e <= O_pos_h;
                    O_moving <= 1;
                end
                else if(O_pos_f == 4'b1000) begin
                    O_pos_f <= O_pos_i;
                    O_pos_i <= O_pos_f;
                    O_moving <= 1;
                end
                else O_moving <= 0;
            end
            default: O_moving <= 0;
            endcase
        end
        else begin
            casex ({W_left, W_right, W_up, W_down})
            4'b1xxx: begin
                if(O_pos_b[1:0] == 2'b10) begin
                    O_pos_b <= O_pos_a;
                    O_pos_a <= O_pos_b;
                    O_moving <= 1;
                end
                else if(O_pos_d[1:0] == 2'b10) begin
                    O_pos_d <= O_pos_c;
                    O_pos_c <= O_pos_d;
                    O_moving <= 1;
                end
                else O_moving <= 0;
            end
            4'b01xx: begin
                    if(O_pos_a[1:0] == 2'b10) begin
                    O_pos_b <= O_pos_a;
                    O_pos_a <= O_pos_b;
                    O_moving <= 1;
                end
                else if(O_pos_c[1:0] == 2'b10) begin
                    O_pos_c <= O_pos_d;
                    O_pos_d <= O_pos_c;
                    O_moving <= 1;
                end
                else O_moving <= 0;
            end
            4'b001x: begin
                if(O_pos_c[1:0] == 2'b10) begin
                    O_pos_a <= O_pos_c;
                    O_pos_c <= O_pos_a;
                    O_moving <= 1;
                end
                else if(O_pos_d[1:0] == 2'b10) begin
                    O_pos_b <= O_pos_d;
                    O_pos_d <= O_pos_b;
                    O_moving <= 1;
                end
                else O_moving <= 0;
            end
            4'b0001: begin
                if(O_pos_a[1:0] == 2'b10) begin
                    O_pos_c <= O_pos_a;
                    O_pos_a <= O_pos_c;
                    O_moving <= 1;
                end
                else if(O_pos_b[1:0] == 2'b10) begin
                    O_pos_d <= O_pos_b;
                    O_pos_b <= O_pos_d;
                    O_moving <= 1;
                end
                else O_moving <= 0;
            end
            default: O_moving <= 0;
            endcase

        end
    end
end

endmodule