// 管理像素溢出，rgb332 to rgb444

module pixel_ctrl(
    input I_clk_25M, // the same frequency as memory read clock
    input I_rst_n,
    input [9:0] I_pixel_x,
    input [9:0] I_pixel_y,
    input [7:0] I_pixel_data,
    input I_black_EN,
    output [11:0] O_pixel_data,

    input [3:0] I_pos_a,
    input [3:0] I_pos_b,
    input [3:0] I_pos_c,
    input [3:0] I_pos_d,
    input [3:0] I_pos_e,
    input [3:0] I_pos_f,
    input [3:0] I_pos_g,
    input [3:0] I_pos_h,  
    input [3:0] I_pos_i,
    output [17:0] O_read_addr,

    input I_hard_mode
);
parameter C_PIC_WIDTH = 10'd480;
parameter C_PIC_HEIGHT = 10'd480;    
localparam C_PIC_WIDTH_HALF = 10'd240;
localparam C_PIC_HEIGHT_HALF = 10'd240;
parameter C_PIC_WIDTH_1_3 = 10'd160;
parameter C_PIC_WIDTH_2_3 = 10'd320;
parameter C_PIC_HEIGHT_1_3 = 10'd160;
parameter C_PIC_HEIGHT_2_3 = 10'd320;

wire pixel_within_range;
assign pixel_within_range = (I_pixel_x < C_PIC_WIDTH) && (I_pixel_y < C_PIC_HEIGHT);


wire [9:0] pixel_x_tran;
wire [9:0] pixel_y_tran;

pixel_transformer ptran_inst(
    .I_pixel_x(I_pixel_x),
    .I_pixel_y(I_pixel_y),
    .I_pos_a(I_pos_a),
    .I_pos_b(I_pos_b),
    .I_pos_c(I_pos_c),
    .I_pos_d(I_pos_d),
    .I_pos_e(I_pos_e),
    .I_pos_f(I_pos_f),
    .I_pos_g(I_pos_g),
    .I_pos_h(I_pos_h),
    .I_pos_i(I_pos_i),
    .I_EN(pixel_within_range),
    .O_pixel_x(pixel_x_tran),
    .O_pixel_y(pixel_y_tran),
    .I_hard_mode(I_hard_mode)
);

assign O_read_addr = pixel_y_tran * C_PIC_WIDTH + pixel_x_tran;

wire [11:0] pixel_data;
assign pixel_data = ((I_pixel_x < C_PIC_WIDTH) && (I_pixel_y < C_PIC_HEIGHT)) ? ({
    I_pixel_data[7:5], I_pixel_data[5],
    I_pixel_data[4:2], I_pixel_data[2],
    I_pixel_data[1:0], I_pixel_data[1:0]
}) : 12'b0;

// wait for two cycles !!!
reg pixel_black, pixel_black_tmp;
always @(posedge I_clk_25M, negedge I_rst_n) begin
    if(~I_rst_n) {pixel_black, pixel_black_tmp} <= 2'b0;
    else begin
        pixel_black_tmp <= I_black_EN && (
            I_hard_mode 
            ? ((pixel_x_tran < C_PIC_WIDTH_1_3) && (pixel_y_tran < C_PIC_HEIGHT) && (pixel_y_tran >= C_PIC_HEIGHT_2_3))
            : ((pixel_x_tran < C_PIC_WIDTH_HALF) && (pixel_y_tran < C_PIC_HEIGHT) && (pixel_y_tran >= C_PIC_HEIGHT_HALF))
        );
        pixel_black <= pixel_black_tmp;
    end
end

assign O_pixel_data = pixel_black ? 12'b0 : pixel_data;


endmodule
