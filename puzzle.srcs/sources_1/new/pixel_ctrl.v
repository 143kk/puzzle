// 管理像素溢出，rgb332 to rgb444

module pixel_ctrl(
    input [9:0] I_pixel_x,
    input [9:0] I_pixel_y,
    input [7:0] I_pixel_data,
    input I_black_EN,
    output [11:0] O_pixel_data,

    input [1:0] I_pos_a,
    input [1:0] I_pos_b,
    input [1:0] I_pos_c,
    input [1:0] I_pos_d,
    output [17:0] O_read_addr
);
parameter C_PIC_WIDTH = 480;
parameter C_PIC_HEIGHT = 480;    
localparam C_PIC_WIDTH_HALF = C_PIC_WIDTH / 2;
localparam C_PIC_HEIGHT_HALF = C_PIC_HEIGHT / 2;

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
    .I_EN(pixel_within_range),
    .O_pixel_x(pixel_x_tran),
    .O_pixel_y(pixel_y_tran)
);

assign O_read_addr = pixel_y_tran * C_PIC_WIDTH + pixel_x_tran;
//assign O_read_addr = I_pixel_y * C_PIC_WIDTH + I_pixel_x;

wire [11:0] pixel_data;
assign pixel_data = ((I_pixel_x < C_PIC_WIDTH) && (I_pixel_y < C_PIC_HEIGHT)) ? ({
    I_pixel_data[7:5], I_pixel_data[5],
    I_pixel_data[4:2], I_pixel_data[2],
    I_pixel_data[1:0], I_pixel_data[1:0]
}) : 12'b0;

assign O_pixel_data = (
    I_black_EN && (pixel_x_tran < C_PIC_WIDTH_HALF) && (pixel_y_tran < C_PIC_HEIGHT) && (pixel_y_tran >= C_PIC_HEIGHT_HALF)
) ? 12'b0 : pixel_data;


endmodule
