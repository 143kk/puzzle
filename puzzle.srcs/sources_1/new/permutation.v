module permutation(
    input [4:0] I_num,
    output O_num_valid,
    output reg [1:0] O_pos_a,
    output reg [1:0] O_pos_b,
    output reg [1:0] O_pos_c,
    output reg [1:0] O_pos_d
);

// 5'b00000 - 5'b10111为有效位
assign O_num_valid = I_num <= 5'b10111;

always @(*) begin
    case (I_num)
        5'd0: begin
            O_pos_a = 2'd0;
            O_pos_b = 2'd1;
            O_pos_c = 2'd2;
            O_pos_d = 2'd3;
        end
        5'd1: begin
            O_pos_a = 2'd0;
            O_pos_b = 2'd1;
            O_pos_c = 2'd3;
            O_pos_d = 2'd2;
        end
        5'd2: begin
            O_pos_a = 2'd0;
            O_pos_b = 2'd2;
            O_pos_c = 2'd1;
            O_pos_d = 2'd3;
        end
        5'd3: begin
            O_pos_a = 2'd0;
            O_pos_b = 2'd2;
            O_pos_c = 2'd3;
            O_pos_d = 2'd1;
        end
        5'd4: begin
            O_pos_a = 2'd0;
            O_pos_b = 2'd3;
            O_pos_c = 2'd1;
            O_pos_d = 2'd2;
        end
        5'd5: begin
            O_pos_a = 2'd0;
            O_pos_b = 2'd3;
            O_pos_c = 2'd2;
            O_pos_d = 2'd1;
        end
        5'd6: begin
            O_pos_a = 2'd1;
            O_pos_b = 2'd0;
            O_pos_c = 2'd2;
            O_pos_d = 2'd3;
        end
        5'd7: begin
            O_pos_a = 2'd1;
            O_pos_b = 2'd0;
            O_pos_c = 2'd3;
            O_pos_d = 2'd2;
        end
        5'd8: begin
            O_pos_a = 2'd1;
            O_pos_b = 2'd2;
            O_pos_c = 2'd3;
            O_pos_d = 2'd0;
        end
        5'd9: begin
            O_pos_a = 2'd1;
            O_pos_b = 2'd2;
            O_pos_c = 2'd0;
            O_pos_d = 2'd3;
        end
        5'd10: begin
            O_pos_a = 2'd1;
            O_pos_b = 2'd3;
            O_pos_c = 2'd0;
            O_pos_d = 2'd2;
        end
        5'd11: begin
            O_pos_a = 2'd1;
            O_pos_b = 2'd3;
            O_pos_c = 2'd2;
            O_pos_d = 2'd0;
        end
        5'd12: begin
            O_pos_a = 2'd2;
            O_pos_b = 2'd0;
            O_pos_c = 2'd1;
            O_pos_d = 2'd3;
        end
        5'd13: begin
            O_pos_a = 2'd2;
            O_pos_b = 2'd0;
            O_pos_c = 2'd3;
            O_pos_d = 2'd1;
        end
        5'd14: begin
            O_pos_a = 2'd2;
            O_pos_b = 2'd1;
            O_pos_c = 2'd0;
            O_pos_d = 2'd3;
        end
        5'd15: begin
            O_pos_a = 2'd2;
            O_pos_b = 2'd1;
            O_pos_c = 2'd3;
            O_pos_d = 2'd0;
        end
        5'd16: begin
            O_pos_a = 2'd2;
            O_pos_b = 2'd3;
            O_pos_c = 2'd0;
            O_pos_d = 2'd1;
        end
        5'd17: begin
            O_pos_a = 2'd2;
            O_pos_b = 2'd3;
            O_pos_c = 2'd1;
            O_pos_d = 2'd0;
        end
        5'd18: begin
            O_pos_a = 2'd3;
            O_pos_b = 2'd0;
            O_pos_c = 2'd1;
            O_pos_d = 2'd2;
        end
        5'd19: begin
            O_pos_a = 2'd3;
            O_pos_b = 2'd0;
            O_pos_c = 2'd2;
            O_pos_d = 2'd1;
        end
        5'd20: begin
            O_pos_a = 2'd3;
            O_pos_b = 2'd1;
            O_pos_c = 2'd0;
            O_pos_d = 2'd2;
        end
        5'd21: begin
            O_pos_a = 2'd3;
            O_pos_b = 2'd1;
            O_pos_c = 2'd2;
            O_pos_d = 2'd0;
        end
        5'd22: begin
            O_pos_a = 2'd3;
            O_pos_b = 2'd2;
            O_pos_c = 2'd0;
            O_pos_d = 2'd1;
        end
        5'd23: begin
            O_pos_a = 2'd3;
            O_pos_b = 2'd2;
            O_pos_c = 2'd1;
            O_pos_d = 2'd0;
        end
    endcase
end

endmodule
