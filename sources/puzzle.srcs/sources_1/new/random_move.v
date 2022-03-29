module random_move(
    input I_clk, // the same frequency as in game_control module
    input I_rst_n,
    input I_en,
    output reg O_mv_left,
    output reg O_mv_right,
    output reg O_mv_up,
    output reg O_mv_down
);

parameter C_NUM_BITS = 32;

wire [C_NUM_BITS-1:0] W_LFSR_Data;

LFSR #(.NUM_BITS(C_NUM_BITS)) lfsr_inst(
    .i_Clk(I_clk),
    .i_Enable(1'b1),
    .i_Seed_DV(1'b0),
    .i_Seed_Data({C_NUM_BITS{1'b0}}),
    .o_LFSR_Data(W_LFSR_Data)
);

reg [13:0] cnt1 = 0;
reg [13:0] cnt2 = 0;

always @(posedge I_clk, negedge I_rst_n) begin
    if(~I_rst_n) cnt1 <= 0;
    else if(~I_en) cnt1 <= 0;
    else if(cnt1 == 14'd5000) cnt1 <= 0;
    else cnt1 <= cnt1 + 1;
end

always @(posedge I_clk, negedge I_rst_n) begin
    if(~I_rst_n) cnt2 <= 0;
    else if(~I_en) cnt2 <= 0;
    else if(cnt1 == 14'd5000) cnt2 <= cnt2 + 1;
    else if(cnt2 == 14'd100) cnt2 <= 0;
end

always @(posedge I_clk, negedge I_rst_n) begin
    if(~I_rst_n) begin
        {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b0000;
    end
    else begin
        if(~I_en) {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b0000;
        else if(cnt2 == 14'd100)
            case (W_LFSR_Data[1:0])
                2'b00: {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b0001;
                2'b01: {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b0010;
                2'b10: {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b0100;
                2'b11: {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b1000;
            endcase
        else {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b0000;
    end
end
endmodule
