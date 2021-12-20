module random_move(
    input I_clk, // the same frequency as in game_control module
    input I_rst_n,
    input I_en,
    output reg O_mv_left,
    output reg O_mv_right,
    output reg O_mv_up,
    output reg O_mv_down
);

parameter C_NUM_BITS = 8;

wire [C_NUM_BITS-1:0] W_LFSR_Data;

LFSR #(.NUM_BITS(C_NUM_BITS)) lfsr_inst(
    .i_Clk(I_clk),
    .i_Enable(I_en),
    .i_Seed_DV(1'b0),
    .i_Seed_Data({C_NUM_BITS{1'b0}}),
    .o_LFSR_Data(W_LFSR_Data)
);

always @(posedge I_clk, negedge I_rst_n) begin
    if(~I_rst_n) begin
        {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b0;
    end
    else begin
        case (W_LFSR_Data[1:0])
            2'b00: {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b0001;
            2'b01: {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b0010;
            2'b10: {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b0100;
            2'b11: {O_mv_left, O_mv_right, O_mv_up, O_mv_down} <= 4'b1000;
        endcase
    end
end
endmodule
