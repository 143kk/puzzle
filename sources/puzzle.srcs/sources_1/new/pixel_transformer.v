// 坐标变换

module pixel_transformer(
    // 拼图位置
    input [3:0] I_pos_a,
    input [3:0] I_pos_b,
    input [3:0] I_pos_c,
    input [3:0] I_pos_d,
    input [3:0] I_pos_e,
    input [3:0] I_pos_f,
    input [3:0] I_pos_g,
    input [3:0] I_pos_h,  
    input [3:0] I_pos_i,

    input I_hard_mode,

    input [9:0] I_pixel_x,
    input [9:0] I_pixel_y,
    input I_EN, // high active
    output [9:0] O_pixel_x,
    output [9:0] O_pixel_y
);
parameter C_PIC_WIDTH = 10'd480;
parameter C_PIC_HEIGHT = 10'd480;
parameter C_PIC_WIDTH_HALF = 10'd240;
parameter C_PIC_HEIGHT_HALF = 10'd240;
parameter C_PIC_WIDTH_1_3 = 10'd160;
parameter C_PIC_WIDTH_2_3 = 10'd320;
parameter C_PIC_HEIGHT_1_3 = 10'd160;
parameter C_PIC_HEIGHT_2_3 = 10'd320;

wire [9:0] pixel_x_easy;
wire [9:0] pixel_y_easy;
reg [9:0] pixel_x_hard;
reg [9:0] pixel_y_hard;

//assign pixel_x_hard = I_pixel_x;
// assign pixel_y_hard = I_pixel_y;

assign O_pixel_x = I_hard_mode ? pixel_x_hard : pixel_x_easy;
assign O_pixel_y = I_hard_mode ? pixel_y_hard : pixel_y_easy;

assign pixel_x_easy = ~I_EN ? 0 : (
    (I_pixel_x < C_PIC_WIDTH_HALF) ? (
        (I_pixel_y < C_PIC_HEIGHT_HALF) ? (
            // pos a
            I_pixel_x + (I_pos_a[0] ? C_PIC_WIDTH_HALF : 0)
        ) : (
            // pos c
            I_pixel_x + (I_pos_c[0] ? C_PIC_WIDTH_HALF : 0)
        )
    ):(
        (I_pixel_y < C_PIC_HEIGHT_HALF) ? (
            // pos b
            I_pixel_x - (I_pos_b[0] ? 0 : C_PIC_WIDTH_HALF)
        ) : (
            // pos d
            I_pixel_x - (I_pos_d[0] ? 0 : C_PIC_WIDTH_HALF)
        )
    )
);

assign pixel_y_easy = ~I_EN ? 0 : (
    (I_pixel_x < C_PIC_WIDTH_HALF) ? (
        (I_pixel_y < C_PIC_HEIGHT_HALF) ? (
            // pos a
            (I_pixel_y + (I_pos_a[1] ? C_PIC_HEIGHT_HALF : 0))
        ) : (
            // pos c
            (I_pixel_y - (I_pos_c[1] ? 0 : C_PIC_HEIGHT_HALF))
        )
    ):(
        (I_pixel_y < C_PIC_HEIGHT_HALF) ? (
            // pos b
            (I_pixel_y + (I_pos_b[1] ? C_PIC_HEIGHT_HALF : 0))
        ) : (
            // pos d
            (I_pixel_y - (I_pos_d[1] ? 0 : C_PIC_HEIGHT_HALF))
        )
    )
);

always @(*) begin
    if(~I_EN) pixel_x_hard = 0;
    else begin
        if(I_pixel_x < C_PIC_WIDTH_1_3) begin
            if(I_pixel_y < C_PIC_HEIGHT_1_3) begin
                // pos a
                if(I_pos_a[1:0] == 2'b00) pixel_x_hard = I_pixel_x;
                else if(I_pos_a[1:0] == 2'b01) pixel_x_hard = I_pixel_x + C_PIC_WIDTH_1_3;
                else pixel_x_hard = I_pixel_x + C_PIC_WIDTH_2_3;
            end
            else if(I_pixel_y < C_PIC_HEIGHT_2_3) begin
                // pos d
                if(I_pos_d[1:0] == 2'b00) pixel_x_hard = I_pixel_x;
                else if(I_pos_d[1:0] == 2'b01) pixel_x_hard = I_pixel_x + C_PIC_WIDTH_1_3;
                else pixel_x_hard = I_pixel_x + C_PIC_WIDTH_2_3;
            end
            else begin
                // pos g
                if(I_pos_g[1:0] == 2'b00) pixel_x_hard = I_pixel_x;
                else if(I_pos_g[1:0] == 2'b01) pixel_x_hard = I_pixel_x + C_PIC_WIDTH_1_3;
                else pixel_x_hard = I_pixel_x + C_PIC_WIDTH_2_3;
            end
        end
        else if(I_pixel_x < C_PIC_WIDTH_2_3) begin
            if(I_pixel_y < C_PIC_HEIGHT_1_3) begin
                // pos b
                if(I_pos_b[1:0] == 2'b00) pixel_x_hard = I_pixel_x - C_PIC_WIDTH_1_3;
                else if(I_pos_b[1:0] == 2'b01) pixel_x_hard = I_pixel_x;
                else pixel_x_hard = I_pixel_x + C_PIC_WIDTH_1_3;
            end
            else if(I_pixel_y < C_PIC_HEIGHT_2_3) begin
                // pos e
                if(I_pos_e[1:0] == 2'b00) pixel_x_hard = I_pixel_x - C_PIC_WIDTH_1_3;
                else if(I_pos_e[1:0] == 2'b01) pixel_x_hard = I_pixel_x;
                else pixel_x_hard = I_pixel_x + C_PIC_WIDTH_1_3;
            end
            else begin
                // pos h
                if(I_pos_h[1:0] == 2'b00) pixel_x_hard = I_pixel_x - C_PIC_WIDTH_1_3;
                else if(I_pos_h[1:0] == 2'b01) pixel_x_hard = I_pixel_x;
                else pixel_x_hard = I_pixel_x + C_PIC_WIDTH_1_3;
            end
        end
        else begin
            if(I_pixel_y < C_PIC_HEIGHT_1_3) begin
                // pos c
                if(I_pos_c[1:0] == 2'b00) pixel_x_hard = I_pixel_x - C_PIC_WIDTH_2_3;
                else if(I_pos_c[1:0] == 2'b01) pixel_x_hard = I_pixel_x - C_PIC_WIDTH_1_3;
                else pixel_x_hard = I_pixel_x;
            end
            else if(I_pixel_y < C_PIC_HEIGHT_2_3) begin
                // pos f
                if(I_pos_f[1:0] == 2'b00) pixel_x_hard = I_pixel_x - C_PIC_WIDTH_2_3;
                else if(I_pos_f[1:0] == 2'b01) pixel_x_hard = I_pixel_x - C_PIC_WIDTH_1_3;
                else pixel_x_hard = I_pixel_x;
            end
            else begin
                // pos i
                if(I_pos_i[1:0] == 2'b00) pixel_x_hard = I_pixel_x - C_PIC_WIDTH_2_3;
                else if(I_pos_i[1:0] == 2'b01) pixel_x_hard = I_pixel_x - C_PIC_WIDTH_1_3;
                else pixel_x_hard = I_pixel_x;
            end
        end
    end
end

always @(*) begin
    if(~I_EN) pixel_y_hard = 0;
    else begin
        if(I_pixel_y < C_PIC_HEIGHT_1_3) begin
            if(I_pixel_x < C_PIC_WIDTH_1_3) begin
                // pos a
                if(I_pos_a[3:2] == 2'b00) pixel_y_hard = I_pixel_y;
                else if(I_pos_a[3:2] == 2'b01) pixel_y_hard = I_pixel_y + C_PIC_HEIGHT_1_3;
                else pixel_y_hard = I_pixel_y + C_PIC_HEIGHT_2_3;
            end
            else if(I_pixel_x < C_PIC_WIDTH_2_3) begin
                // pos b
                if(I_pos_b[3:2] == 2'b00) pixel_y_hard = I_pixel_y;
                else if(I_pos_b[3:2] == 2'b01) pixel_y_hard = I_pixel_y + C_PIC_HEIGHT_1_3;
                else pixel_y_hard = I_pixel_y + C_PIC_HEIGHT_2_3;
            end
            else begin
                // pos c
                if(I_pos_c[3:2] == 2'b00) pixel_y_hard = I_pixel_y;
                else if(I_pos_c[3:2] == 2'b01) pixel_y_hard = I_pixel_y + C_PIC_HEIGHT_1_3;
                else pixel_y_hard = I_pixel_y + C_PIC_HEIGHT_2_3;
            end
        end
        else if(I_pixel_y < C_PIC_HEIGHT_2_3) begin
            if(I_pixel_x < C_PIC_WIDTH_1_3) begin
                // pos d
                if(I_pos_d[3:2] == 2'b00) pixel_y_hard = I_pixel_y - C_PIC_HEIGHT_1_3;
                else if(I_pos_d[3:2] == 2'b01) pixel_y_hard = I_pixel_y;
                else pixel_y_hard = I_pixel_y + C_PIC_HEIGHT_1_3;
            end
            else if(I_pixel_x < C_PIC_WIDTH_2_3) begin
                // pos e
                if(I_pos_e[3:2] == 2'b00) pixel_y_hard = I_pixel_y - C_PIC_HEIGHT_1_3;
                else if(I_pos_e[3:2] == 2'b01) pixel_y_hard = I_pixel_y;
                else pixel_y_hard = I_pixel_y + C_PIC_HEIGHT_1_3;
            end
            else begin
                // pos f
                if(I_pos_f[3:2] == 2'b00) pixel_y_hard = I_pixel_y - C_PIC_HEIGHT_1_3;
                else if(I_pos_f[3:2] == 2'b01) pixel_y_hard = I_pixel_y;
                else pixel_y_hard = I_pixel_y + C_PIC_HEIGHT_1_3;
            end
        end
        else begin
            if(I_pixel_x < C_PIC_WIDTH_1_3) begin
                // pos g
                if(I_pos_g[3:2] == 2'b00) pixel_y_hard = I_pixel_y - C_PIC_HEIGHT_2_3;
                else if(I_pos_g[3:2] == 2'b01) pixel_y_hard = I_pixel_y - C_PIC_HEIGHT_1_3;
                else pixel_y_hard = I_pixel_y;
            end
            else if(I_pixel_x < C_PIC_WIDTH_2_3) begin
                // pos h
                if(I_pos_h[3:2] == 2'b00) pixel_y_hard = I_pixel_y - C_PIC_HEIGHT_2_3;
                else if(I_pos_h[3:2] == 2'b01) pixel_y_hard = I_pixel_y - C_PIC_HEIGHT_1_3;
                else pixel_y_hard = I_pixel_y;
            end
            else begin
                // pos i
                if(I_pos_i[3:2] == 2'b00) pixel_y_hard = I_pixel_y - C_PIC_HEIGHT_2_3;
                else if(I_pos_i[3:2] == 2'b01) pixel_y_hard = I_pixel_y - C_PIC_HEIGHT_1_3;
                else pixel_y_hard = I_pixel_y;
            end
        end
    end
end

endmodule
