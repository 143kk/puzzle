module rand_pos(
    input I_clk,
    output [1:0] O_pos_a,
    output [1:0] O_pos_b,
    output [1:0] O_pos_c,
    output [1:0] O_pos_d
);

parameter C_NUM_BITS = 5;

wire [C_NUM_BITS-1:0] W_LFSR_Data;

LFSR #(.NUM_BITS(C_NUM_BITS)) lfsr_inst(
    .i_Clk(I_clk),
    .i_Enable(1'b1),
    .i_Seed_DV(1'b0),
    .i_Seed_Data({C_NUM_BITS{1'b0}}),
    .o_LFSR_Data(W_LFSR_Data)
);

wire [4:0] W_num = W_LFSR_Data % 5'd24;

permutation perm_inst2(
    .I_num(W_num),
    .O_pos_a(O_pos_a),
    .O_pos_b(O_pos_b),
    .O_pos_c(O_pos_c),
    .O_pos_d(O_pos_d)
);

endmodule
